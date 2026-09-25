#!/usr/bin/env bash
# Powerlevel10k "lean"-style statusLine for Claude Code.
#
# No background fill: colored text straight on the terminal background, which
# stays readable on a dark theme and avoids the muddy grey bar. Layout is
# space-between:
#
#   Opus 5   dotfiles  main        ▰▱▱▱▱▱▱▱   12.3k 1.1M 4.5k   $3.42
#
# The chevron separator is used only between repo and branch, because it
# reads as "belongs to". Unrelated segments are separated by whitespace.

export PATH="${HOME}/.local/share/mise/shims:${PATH}"
# ${#s} must count characters, not bytes, or the padding math breaks on the
# multi-byte glyphs.
export LC_ALL=C.UTF-8

set -euo pipefail

input=$(cat)

# Written as \u escapes: these live in the Private Use Area and do not
# survive being pasted around as literals.
CHEVRON=$'\ue0b1'  # powerline thin chevron
MODEL_ICON=$'\uf2db'  # nf-fa-microchip
REPO_ICON=$'\uf401'  # nf-oct-repo
BRANCH_ICON=$'\ue725'  # nf-dev-git_branch
COST_ICON=$'\uf155'  # nf-fa-dollar
IN_ICON=$'\uf431'  # nf-oct-arrow_up
CACHE_ICON=$'\uf021'  # nf-fa-refresh
OUT_ICON=$'\uf433'  # nf-oct-arrow_down

BAR_FILL=$'\u25b0'   # BLACK PARALLELOGRAM
BAR_EMPTY=$'\u25b1'  # WHITE PARALLELOGRAM
BAR_WIDTH=8

# The statusline panel is inset from the terminal edge, so COLUMNS overshoots
# the width we actually get. Leaving a margin keeps the last segment from
# being truncated with an ellipsis.
MARGIN=6

# --- Catppuccin Mocha ---
MAUVE="203;166;247"
BLUE="137;180;250"
GREEN="166;227;161"
YELLOW="249;226;175"
PEACH="250;179;135"
RED="243;139;168"
SUBTEXT0="166;173;200"
# Off-palette tints: midway between Maroon and Flamingo, and Sapphire halfway
# to Text. Lavender reads purple next to Mauve and the cost segment.
SOFT_RED="238;182;188"
TEAL="148;226;213"
SOFT_BLUE="161;207;240"
SURFACE2="88;91;112"

fg() { printf '\e[38;2;%sm' "$1"; }
RESET=$'\e[0m'

# =========================================================================
# left: model,  repo -> branch
# =========================================================================
left=""

model=$(jq -r '.model.display_name // .model.id // "claude"' <<<"${input}")
left+="$(fg "${MAUVE}")${MODEL_ICON} ${model}"

cwd=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"${input}")
project_dir=$(jq -r '.workspace.project_dir // empty' <<<"${input}")
repo_name=$(jq -r '.workspace.repo.name // empty' <<<"${input}")
if [[ -z "${repo_name}" ]]; then
  repo_name=$(basename "${project_dir:-${cwd}}")
fi
left+="   $(fg "${BLUE}")${REPO_ICON} ${repo_name}"

if git -C "${cwd}" rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "${cwd}" branch --show-current 2>/dev/null)
  if [[ -z "${branch}" ]]; then
    branch=$(git -C "${cwd}" rev-parse --short HEAD 2>/dev/null || echo "?")
  fi
  if [[ -n "$(git -C "${cwd}" status --porcelain 2>/dev/null)" ]]; then
    branch_fg="${PEACH}"
    branch="${branch}*"
  else
    branch_fg="${GREEN}"
  fi
  left+=" $(fg "${SURFACE2}")${CHEVRON} $(fg "${branch_fg}")${BRANCH_ICON} ${branch}"
fi

# =========================================================================
# right: context gauge,  cost
# =========================================================================
right=""

ctx_pct=$(jq -r '.context_window.used_percentage // empty' <<<"${input}")
if [[ -n "${ctx_pct}" ]]; then
  ctx=$(printf "%.0f" "${ctx_pct}")
  ((ctx < 0)) && ctx=0
  ((ctx > 100)) && ctx=100

  if ((ctx >= 80)); then
    ctx_fg="${RED}"
  elif ((ctx >= 40)); then
    ctx_fg="${YELLOW}"
  else
    ctx_fg="${GREEN}"
  fi

  # Round up, so any non-zero usage lights at least one cell.
  filled=$(((ctx * BAR_WIDTH + 99) / 100))
  ((filled > BAR_WIDTH)) && filled=${BAR_WIDTH}

  gauge=""
  for ((i = 0; i < filled; i++)); do gauge+="${BAR_FILL}"; done
  gauge+="$(fg "${SURFACE2}")"
  for ((i = filled; i < BAR_WIDTH; i++)); do gauge+="${BAR_EMPTY}"; done

  right+="$(fg "${ctx_fg}")${gauge}"
fi

# The payload's context_window.total_*_tokens only cover the latest request,
# so the session totals are summed from the transcript. Streaming writes one
# line per content block, each repeating the same usage, hence unique_by(id).
# Subagent usage lives in separate transcripts and is not counted.
human() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1e6) printf "%.1fM", n / 1e6
    else if (n >= 1e3) printf "%.1fk", n / 1e3
    else printf "%d", n
  }'
}

transcript=$(jq -r '.transcript_path // empty' <<<"${input}")
if [[ -f "${transcript}" ]]; then
  read -r tok_in tok_cache tok_out < <(
    jq -rn '
      [inputs | select(.type == "assistant" and .message.usage)
        | {id: .message.id, u: .message.usage}]
      | unique_by(.id) | map(.u)
      | [ (map((.input_tokens // 0) + (.cache_creation_input_tokens // 0)) | add // 0),
          (map(.cache_read_input_tokens // 0) | add // 0),
          (map(.output_tokens // 0) | add // 0) ]
      | @tsv' "${transcript}" 2>/dev/null || echo "0 0 0"
  )
  if ((tok_in + tok_cache + tok_out > 0)); then
    [[ -n "${right}" ]] && right+="   "
    right+="$(fg "${SOFT_RED}")${IN_ICON} $(human "${tok_in}")"
    right+=" $(fg "${TEAL}")${CACHE_ICON} $(human "${tok_cache}")"
    right+=" $(fg "${SOFT_BLUE}")${OUT_ICON} $(human "${tok_out}")"
  fi
fi

cost=$(jq -r '.cost.total_cost_usd // empty' <<<"${input}")
if [[ -n "${cost}" ]]; then
  [[ -n "${right}" ]] && right+="   "
  right+="$(fg "${SUBTEXT0}")${COST_ICON}$(printf '%.2f' "${cost}")"
fi

# =========================================================================
# render: space-between
# =========================================================================
visible_len() {
  local s
  s=$(printf '%s' "$1" | sed -E $'s/\x1b\\[[0-9;]*m//g')
  printf '%s' "${#s}"
}

# Claude Code captures our stdout, so there is no tty to query: it exports
# COLUMNS instead (v2.1.153+). 80 is the fallback for older versions.
cols=$((${COLUMNS:-80} - MARGIN))

pad=$((cols - $(visible_len "${left}") - $(visible_len "${right}")))
((pad < 1)) && pad=1

printf '%s%*s%s%s\n' "${left}" "${pad}" "" "${right}" "${RESET}"

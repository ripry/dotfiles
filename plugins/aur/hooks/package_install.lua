-- yay escalates to pacman on its own; the hook never calls sudo itself.

local cmd = require("cmd")
local log = require("log")

local function names_of(packages)
    local names = {}
    for _, package in ipairs(packages) do
        table.insert(names, package.name)
    end
    return names
end

function PLUGIN:PackageInstall(ctx)
    local names = names_of(ctx.packages)
    if #names == 0 then
        return {}
    end

    -- --needed makes a repeat run a no-op; an explicit update has to skip it so
    -- that already-installed packages are actually rebuilt.
    local flags = ctx.update and "-S --noconfirm" or "-S --needed --noconfirm"
    local command = "yay " .. flags .. " " .. table.concat(names, " ")

    if ctx.dry_run then
        log.info("would run: " .. command)
        return {}
    end

    cmd.exec(command)
    return {}
end

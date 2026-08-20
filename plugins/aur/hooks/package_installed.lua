-- Must stay side-effect free, fast and non-interactive, so this reads the local
-- pacman database directly instead of asking yay (which would hit the network).

local cmd = require("cmd")
local strings = require("strings")

local function installed_versions()
    local versions = {}
    local ok, out = pcall(cmd.exec, "pacman -Q")
    if not ok then
        return versions
    end

    for _, line in ipairs(strings.split(out, "\n")) do
        local fields = strings.split(strings.trim_space(line), " ")
        if fields[1] ~= nil and fields[1] ~= "" then
            versions[fields[1]] = fields[2]
        end
    end
    return versions
end

function PLUGIN:PackageInstalled(ctx)
    local versions = installed_versions()
    local packages = {}

    for _, package in ipairs(ctx.packages) do
        local version = versions[package.name]
        if version ~= nil then
            table.insert(packages, {
                name = package.name,
                state = "installed",
                version = version,
            })
        else
            table.insert(packages, {
                name = package.name,
                state = "missing",
            })
        end
    end

    return { packages = packages }
end

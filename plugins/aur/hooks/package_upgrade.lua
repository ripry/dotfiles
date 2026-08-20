-- Without --needed yay reinstalls even when the version string is unchanged,
-- which is what an AUR upgrade of a -git package has to do.

local cmd = require("cmd")
local log = require("log")

function PLUGIN:PackageUpgrade(ctx)
    local names = {}
    for _, package in ipairs(ctx.packages) do
        table.insert(names, package.name)
    end
    if #names == 0 then
        return {}
    end

    local command = "yay -S --noconfirm " .. table.concat(names, " ")

    if ctx.dry_run then
        log.info("would run: " .. command)
        return {}
    end

    cmd.exec(command)
    return {}
end

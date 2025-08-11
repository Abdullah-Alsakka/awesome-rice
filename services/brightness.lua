local awful = require("awful")

local brightness = {}

function brightness.increase()
    awful.spawn.with_shell("brightnessctl s +10%")
end

function brightness.decrease()
    awful.spawn.with_shell("brightnessctl s 10%-")
end

return brightness
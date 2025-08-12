require("develop")
require("globals")

require("core")
require("theme")
require("rice")
require("services")
require("ui")

local awful = require("awful")

-- Run picom with your configuration.
awful.spawn.with_shell("picom --config ~/.config/picom/picom.conf")

-- Run Nitrogen and select a random wallpaper.
awful.spawn.with_shell("nitrogen --random")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

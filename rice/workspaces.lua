local capi = Capi
local pairs = pairs
local core_workspaces = require("core.workspace")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("theme.theme")


---@class Rice.Workspaces
---@field factories table<string, fun(): tag>
local workspaces = {
    factories = {
        hearthstone = function()
            return {
                name = "Hearthstone",
                screen = capi.screen.primary,
            }
        end,
        chat = function()
            return {
                name = "Chat",
            }
        end,
        git = function()
            return {
                name = "Git",
            }
        end,
    },
}

for key, factory in pairs(workspaces.factories) do
    core_workspaces.add(key, factory)
end

-- Define the workspaces (tags) with their startup apps
local defined_workspaces = {
    {
        name = "Main",
        apps = {
            { 
                cmd = "alacritty", 
                class = "Alacritty" 
            },
        },
    },
    {
        name = "Office",
        apps = {
            { 
                cmd = "alacritty", 
                class = "Alacritty" 
            },
            { 
                cmd = "code-oss", 
                class = "Code", -- adjust if your Code instance sets a different wm class
            },
        },
    },
    {
        name = "System",
        apps = {
            { 
                cmd = "alacritty -e htop", 
                class = "Alacritty",
                -- push this app more toward the left with custom placement
                placement = function(c)
                    awful.placement.left(c, { margins = { left = 100 } })
                end,
            },
            { 
                cmd = "alacritty -e glances", 
                class = "Alacritty",
            },
            { 
                cmd = "alacritty -e iftop", 
                class = "Alacritty",
            },
        },
    },
}

-- Spawn the apps for each workspace.
local function spawn_workspace_apps(ws)
    for _, app in ipairs(ws.apps) do
        awful.spawn.with_shell(app.cmd, false, function(c)
            if app.placement then
                app.placement(c)
            end
        end)
    end
end

-- Create tags on each screen and spawn the startup apps.
awful.screen.connect_for_each_screen(function(s)
    -- Create tags based on our workspaces list.
    local tags = {}
    for _, ws in ipairs(defined_workspaces) do
        local tag = awful.tag.add(ws.name, {
            screen = s,
            layout = awful.layout.layouts[1],
        })
        table.insert(tags, tag)
    end
    s.tags = tags

    -- Spawn the apps on each corresponding workspace.
    -- (Adjust your logic if you want the apps to spawn only once or when switching tags.)
    for i, ws in ipairs(defined_workspaces) do
        spawn_workspace_apps(ws)
    end
end)

return workspaces

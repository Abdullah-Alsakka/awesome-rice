local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi
local apps      = require("rice.apps") -- assuming rice/apps.lua returns a table of app definitions

local search_tab = {}

-- Create a textbox widget to allow entry. For a full implementation you might replace this with a text input widget.
local search_edit = wibox.widget {
    widget = wibox.widget.textbox,
    text   = "Type to search...",
    align  = "center",
}

local results_list = wibox.widget {
    widget = wibox.widget.textbox,
    text   = "Results will appear here.",
    align  = "left",
}

-- A basic function to filter apps by name based on the query.
local function perform_search(query)
    local results = {}
    query = query:lower()
    for _, app in ipairs(apps or {}) do
        if app.name and app.name:lower():find(query) then
            table.insert(results, app.name)
        end
    end
    local out = (#results > 0) and table.concat(results, "\n") or "No results"
    results_list.text = out
end

-- For demonstration, update search results when the search_edit text changes.
-- A real implementation would use a proper text input widget.
search_edit:connect_signal("widget::redraw_needed", function()
    local query = search_edit.text or ""
    perform_search(query)
end)

search_tab.widget = wibox.widget {
    layout  = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    search_edit,
    results_list,
}

return search_tab
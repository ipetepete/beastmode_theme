-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('thangs.widgets.clickable-container')
local gears = require('gears')
-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widgets/wifi/icons/'
local interface = 'wlp2s0'
local connected = false
local essid = 'N/A'

local widget =
    wibox.widget {
    {
        id = 'icon',
        widget = wibox.widget.imagebox,
        resize = true
    },
    layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, 4, 4, 4, 4))
widget_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                awful.spawn('wicd-client -n')
            end
        )
    )
)
-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
local widget_popup =
    awful.tooltip(
    {
        objects = {widget_button},
        mode = 'outside',
        align = 'right',
        timer_function = function()
            if connected then
                return 'Connected to ' .. essid
            else
                return 'Wireless network is disconnected'
            end
        end,
        preferred_positions = {'right', 'left', 'top', 'bottom'},
        margin_leftright = 4,
        margin_topbottom = 4
    }
)

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
--beautiful.tooltip_fg = beautiful.fg_normal
--beautiful.tooltip_bg = beautiful.bg_normal

local function show_battery_warning()
    naughty.notify {
        icon = PATH_TO_ICONS .. 'battery-alert.svg',
        icon_size = 48,
        text = 'Huston, we have a problem',
        title = 'Battery is dying',
        timeout = 5,
        hover_timeout = 0.5,
        position = 'bottom_left',
        bg = '#d32f2f',
        fg = '#EEE9EF',
        width = 248
    }
end

local function grabText()
    if connected then
        awful.spawn.easy_async(
            'iw dev ' .. interface .. ' link',
            function(stdout, stderr, reason, exit_code)
                essid = stdout:match('SSID:(.-)\n')
                if (essid == nil) then
                    essid = 'N/A'
                end
            end
        )
    end
end

local last_battery_check = os.time()
watch(
    "awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless",
    5,
    function(widget, stdout, stderr, exitreason, exitcode)
        local widgetIconName = 'wifi-strength'
        local wifi_strength = tonumber(stdout)
        if (wifi_strength ~= nil) then
            connected = true
            --log_this(status)
            -- Update popup text
            local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)
            widgetIconName = widgetIconName .. '-' .. wifi_strength_rounded
            widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
        else
            connect = false
            widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '-off' .. '.svg')
        end
        if (connected and (essid == 'N/A' or essid == nil)) then
            grabText()
        end
    end,
    widget
)

widget:connect_signal(
    'mouse::enter',
    function()
        grabText()
    end
)

return widget_button

local wibox = require('wibox')
local mat_list_item = require('thangs.widgets.mat-list-item')
local mat_slider = require('thangs.widgets.mat-slider')
local mat_icon_button = require('thangs.widgets.mat-icon-button')
local clickable_container = require('thangs.widgets.clickable-container')
local icons = require('thangs.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')

local slider =
  wibox.widget {
  read_only = false,
  widget = mat_slider
}

slider:connect_signal(
  'property::value',
  function()
    spawn('light -S ' .. math.max(slider.value, 5))
  end
)

watch(
  [[bash -c "light -G"]],
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local brightness = string.match(stdout, '(%d+)')

    slider:set_value(tonumber(brightness))
  end
)

local icon =
  wibox.widget {
  image = icons.brightness,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)
button.top = 12
button.bottom = 12
button.left = 12
button.right = 12

local brightness_setting =
  wibox.widget {
  button,
  slider,
  widget = mat_list_item
}

return brightness_setting

local wibox = require('wibox')
local mat_list_item = require('thangs.widgets.mat-list-item')
local mat_slider = require('thangs.widgets.mat-slider')
local mat_icon_button = require('thangs.widgets.mat-icon-button')
local clickable_container = require('thangs.widgets.clickable-container')
local icons = require('thangs.icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local slider =
wibox.widget {
  font = beautiful.font .. ' ' .. beautiful.panel_heading_size,
  align = 'left',
  valign = 'center',
  forced_height = 48,
  widget = wibox.widget.textbox
}

watch(
  [[date]],
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    slider:set_markup(stdout)
  end
)

local icon =
  wibox.widget {
  image = icons.date,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)
button.top = 12
button.bottom = 12
button.left = 12
button.right = 12

local date_info =
  wibox.widget {
  button,
  wibox.container.margin(slider, dpi(0), dpi(0), dpi(12), dpi(0)),
  widget = mat_list_item
}

return date_info

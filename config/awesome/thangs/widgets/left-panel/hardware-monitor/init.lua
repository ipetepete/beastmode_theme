local wibox = require('wibox')
local beautiful = require('beautiful')
local mat_list_item = require('thangs.widgets.mat-list-item')

local title = wibox.widget {
  text = 'Hardware monitor',
  font = beautiful.font .. ' '..beautiful.panel_heading_size,
  widget = wibox.widget.textbox
}

title = wibox.container.margin(title, 69, 12, 24, 12);

return wibox.widget {
  title,
  require('thangs.widgets.left-panel.hardware-monitor.cpu-meter'),
  require('thangs.widgets.left-panel.hardware-monitor.ram-meter'),
  require('thangs.widgets.left-panel.hardware-monitor.temperature-meter'),
  require('thangs.widgets.left-panel.hardware-monitor.harddrive-meter'),
  layout = wibox.layout.fixed.vertical
}

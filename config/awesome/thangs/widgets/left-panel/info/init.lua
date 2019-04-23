local wibox = require('wibox')
local beautiful = require('beautiful')
local mat_list_item = require('thangs.widgets.mat-list-item')

local title = wibox.widget {
  text = 'Info',
  font = beautiful.font .. ' '..beautiful.panel_heading_size,
  widget = wibox.widget.textbox
}
title = wibox.container.margin(title, 69, 12, 24, 12);

return wibox.widget {
  title,
  require('thangs.widgets.left-panel.info.date-time'),
  require('thangs.widgets.left-panel.info.wifi'),
  require('thangs.widgets.left-panel.info.eth'),
  layout = wibox.layout.fixed.vertical
}

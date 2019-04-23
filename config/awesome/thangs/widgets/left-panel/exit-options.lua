local mat_icon_button = require('thangs.widgets.mat-icon-button')
local wibox = require('wibox')
local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')

local suspend_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'snowflake.png'))
suspend_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl suspend')
      end
    )
  )
)
local restart_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'restart.png'))
restart_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl reboot')
      end
    )
  )
)
local shutdown_button = mat_icon_button(wibox.widget.imagebox(beautiful.icons .. 'power.png'))
shutdown_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('systemctl poweroff')
      end
    )
  )
)
local shutdown_menu = {
  {
    layout = wibox.layout.fixed.vertical,
    {
      {
        markup = 'Exit options',
        align = 'left',
        valign = 'center',
        font = beautiful.title_font,
        widget = wibox.widget.textbox
      },
      bottom = 8,
      widget = wibox.container.margin
    },
    {
      layout = wibox.layout.fixed.horizontal,
      forced_height = 48,
      suspend_button,
      restart_button,
      shutdown_button
    }
  },
  top = 16,
  left = 16,
  right = 16,
  bottom = 16,
  widget = wibox.container.margin
}

return shutdown_menu

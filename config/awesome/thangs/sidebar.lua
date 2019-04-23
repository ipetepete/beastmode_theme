local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

-- Some commonly used variables
local playerctl_button_size = dpi(48)
local icon_size = dpi(36)
local progress_bar_width = dpi(215)
-- local progress_bar_margins = dpi(9)

-- import some widgets
local icons = require('thangs.icons')
-- Item configuration
local exit_icon = wibox.widget.imagebox(icons.power)
exit_icon.resize = true
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = "sans 14"

local exit = wibox.widget{
  exit_icon,
  exit_text,
  layout = wibox.layout.fixed.horizontal
}
exit:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     exit_screen_show()
                     sidebar.visible = false
                 end)
))

local xkcd_tfile = io.open(os.getenv("HOME").. "/Downloads/xkcd_text.txt", "r")

io.input(xkcd_tfile)
local xkcd_text = {}

line = io.read()
while line do
  for k, v in string.gmatch(line, "([^:]+):%s(.*)") do
    xkcd_text[k] = v
  end
  line = io.read()
end
xkcd_tfile:close()

local xkcd_image = wibox.widget.imagebox(os.getenv("HOME") .. "/Downloads/xkcd.jpg")
xkcd_image.resize = true
local xkcd_title = wibox.widget.textbox(xkcd_text['title'])
local xkcd_alt = wibox.widget.textbox(xkcd_text['alt_text'])
xkcd_title.align = "center"
xkcd_title.font = "sans 14"

xkcd_alt.align = "center"
local xkcd = wibox.widget{
  xkcd_title,
  pad(.5),
  wibox.widget{
    xkcd_image,
    margins = 20,
    layout = wibox.container.margin
  },
  xkcd_alt,
  layout = wibox.layout.fixed.vertical
}

local time = wibox.widget.textclock("%I:%M %B %d")
time.align = "center"
time.valign = "center"
time.font = "sans 35"
time:buttons(gears.table.join(
                awful.button({ }, 1, function ()
                    calendar_toggle()
                end),
                awful.button({ }, 3, function ()
                    calendar_toggle()
                end)
))

local date = wibox.widget.textclock("%B %d")
-- local date = wibox.widget.textclock("%A, %B %d")
-- local date = wibox.widget.textclock("%A, %B %d, %Y")
date.align = "center"
date.valign = "center"
date.font = "sans medium 16"
date:buttons(gears.table.join(
                awful.button({ }, 1, function ()
                    calendar_toggle()
                end),
                awful.button({ }, 3, function ()
                    calendar_toggle()
                end)
))

-- local fancy_date = wibox.widget.textclock("%-j days around the sun")
local fancy_date = wibox.widget.textclock("Knowing that today is %A fills you with determination.")
fancy_date.align = "center"
fancy_date.valign = "center"
fancy_date.font = "sans italic 11"
fancy_date:buttons(gears.table.join(
                awful.button({ }, 1, function ()
                    calendar_toggle()
                end),
                awful.button({ }, 3, function ()
                    calendar_toggle()
                end)
))

local search_icon = wibox.widget.imagebox(icons.search)
search_icon.resize = true
search_icon.forced_width = icon_size
search_icon.forced_height = icon_size
local search_text = wibox.widget.textbox("Search")
search_text.font = "sans 14"

local search = wibox.widget{
  search_icon,
  search_text,
  layout = wibox.layout.fixed.horizontal
}
search:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     awful.spawn.with_shell("rofi -show combi -modi run,drun --config ".. os.getenv("HOME").."/.config/rofi/config.rasi")
                     sidebar.visible = false
                 end),
                 awful.button({ }, 3, function ()
                     awful.spawn.with_shell("rofi -show run")
                     sidebar.visible = false
                 end)
))

-- Create the sidebar
sidebar = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock"})
sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or dpi(300)
sidebar.bar_width = beautiful.sidebar_bar_width or dpi(20)
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.sidebar_border_radius or 0
if beautiful.sidebar_position == "right" then
  sidebar.x = awful.screen.focused().geometry.width - sidebar.width
  sidebar.shape = helpers.prrect(radius, true, false, false, true)
else
  sidebar.x = beautiful.sidebar_x or 0
  sidebar.shape = helpers.prrect(radius, false, true, true, false)
end
-- sidebar.shape = helpers.rrect(radius)

sidebar:buttons(gears.table.join(
                  -- Middle click - Hide sidebar
                  awful.button({ }, 2, function ()
                      sidebar.visible = false
                  end)
                  -- Right click - Hide sidebar
                  -- awful.button({ }, 3, function ()
                  --     sidebar.visible = false
                  --     -- mymainmenu:show()
                  -- end)
))

-- Hide sidebar when mouse leaves
if beautiful.sidebar_hide_on_mouse_leave then
  sidebar:connect_signal("mouse::leave", function ()
                           sidebar.visible = false
  end)
end
-- Activate sidebar by moving the mouse at the edge of the screen
if beautiful.sidebar_hide_on_mouse_leave then
  local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true})
  sidebar_activator.height = sidebar.height
  -- sidebar_activator.height = sidebar.height - beautiful.wibar_height
  sidebar_activator:connect_signal("mouse::enter", function ()
                                     sidebar.visible = true
  end)

  if beautiful.sidebar_position == "right" then
    sidebar_activator.x = awful.screen.focused().geometry.width - sidebar_activator.width
  else
    sidebar_activator.x = 0
  end

  sidebar_activator:buttons(
    gears.table.join(
      -- awful.button({ }, 2, function ()
      --     start_screen_show()
      --     -- sidebar.visible = not sidebar.visible
      -- end),
      awful.button({ }, 4, function ()
          awful.tag.viewprev()
      end),
      awful.button({ }, 5, function ()
          awful.tag.viewnext()
      end)
  ))
end

-- Item placement
sidebar:setup {
  { ----------- TOP GROUP -----------
    pad(1),
    time,
    pad(1),
    xkcd,
    layout = wibox.layout.fixed.vertical
  },
  { ----------- MIDDLE GROUP -----------

    require('thangs.widgets.left-panel.quick-settings'),
    require('thangs.widgets.left-panel.hardware-monitor'),
    pad(1),
    pad(1),
    pad(1),
    pad(1),
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- BOTTOM GROUP -----------
    { -- Search and exit screen
      nil,
      {
        search,
        pad(5),
        exit,
        pad(2),
        layout = wibox.layout.fixed.horizontal
      },
      nil,
      layout = wibox.layout.align.horizontal,
      expand = "none"
    },
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  layout = wibox.layout.align.vertical,
  -- expand = "none"
}

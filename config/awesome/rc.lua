-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local watch = require('awful.widget.watch')

require("thangs.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                                  title = "Oops, there were errors during startup!",
                                  text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                                      title = "Oops, an error happened!",
                                      text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv("HOME").."/.config/awesome/themes/cesious/theme.lua")
beautiful.icon_theme        = "Papirus-Dark"
beautiful.font              = "Noto Sans Regular 10"
beautiful.notification_font = "Noto Sans Bold 14"
beautiful.wibar_height      = 20

-- Get colors from .Xresources and set fallback colors
beautiful.xbackground = xrdb.background or "#333333"
beautiful.xforeground = xrdb.foreground or "#F1FCF9"
beautiful.xcolor0     = xrdb.color0     or "#20262C"
beautiful.xcolor1     = xrdb.color1     or "#DB86BA"
beautiful.xcolor2     = xrdb.color2     or "#74DD91"
beautiful.xcolor3     = xrdb.color3     or "#E49186"
beautiful.xcolor4     = xrdb.color4     or "#75DBE1"
beautiful.xcolor5     = xrdb.color5     or "#B4A1DB"
beautiful.xcolor6     = xrdb.color6     or "#9EE9EA"
beautiful.xcolor7     = xrdb.color7     or "#F1FCF9"
beautiful.xcolor8     = xrdb.color8     or "#465463"
beautiful.xcolor9     = xrdb.color9     or "#D04E9D"
beautiful.xcolor10    = xrdb.color10    or "#4BC66D"
beautiful.xcolor11    = xrdb.color11    or "#DB695B"
beautiful.xcolor12    = xrdb.color12    or "#3DBAC2"
beautiful.xcolor13    = xrdb.color13    or "#825ECE"
beautiful.xcolor14    = xrdb.color14    or "#62CDCD"
beautiful.xcolor15    = xrdb.color15    or "#E0E5E5"

-- This is how to get other .Xresources values (beyond colors 0-15, or custom variables)
-- local cool_color = awesome.xrdb_get_value("", "color16")

beautiful.bg_dark       = beautiful.color8
beautiful.bg_normal     = beautiful.xbackground
beautiful.bg_focus      = "#333333" --beautiful.xcolor1
beautiful.bg_urgent     = beautiful.xcolor9
beautiful.bg_minimize   = beautiful.xcolor15
beautiful.bg_systray    = beautiful.xbackground

beautiful.fg_normal     = beautiful.xforeground
beautiful.fg_focus      = beautiful.xforeground
beautiful.fg_urgent     = beautiful.xcolor12
beautiful.fg_minimize   = beautiful.xforeground

beautiful.medium_dark   = beautiful.xcolor8
beautiful.selected      = beautiful.xcolor9

-- Borders
beautiful.border_width  = dpi(0)
beautiful.border_color = beautiful.xcolor8
beautiful.border_normal = beautiful.xcolor8
beautiful.border_focus  = beautiful.xcolor8
-- Rounded corners
beautiful.border_radius = dpi(10)
-- Gaps
beautiful.useless_gap   = dpi(12)
beautiful.border_width  = dpi(0)
beautiful.screen_margin = dpi(12)
-- Sidebar
beautiful.sidebar_bg = theme.xcolor13
beautiful.sidebar_fg = theme.xbackground
beautiful.sidebar_opacity = 1
beautiful.sidebar_position = "right"
beautiful.sidebar_width = 424
beautiful.sidebar_bar_width = 20
beautiful.panel_heading_size = 18
beautiful.sidebar_hide_on_mouse_leave = true


-- require('thangs.sidebar')

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "emacs"
terminal = os.getenv("TERMINAL") or "kitty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
    { "manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
    { "edit config", gui_editor .. " " .. awesome.conffile,  menubar.utils.lookup_icon("accessories-text-editor") },
    { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
myexitmenu = {
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}
mymainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M ")

-- Temperature indicator

local temp = wibox.widget.textbox("45")
-- temp.font = "sans 10"
local max_temp = 80
watch(
  'bash -c "i8kctl temp"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local tempr = stdout:match('(%d+)')
    temp.text = tempr .."º"
  end
)



-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

darkblue    = beautiful.bg_focus
divider_color = beautiful.xcolor12
red         = "#EB8F8F"
separator = wibox.widget.textbox(' <span color="' .. divider_color .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. divider_color .. '"> </span>')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height=beautiful.wibar_height})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
            separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            separator,
            mykeyboardlayout,
            separator,
            temp, 
            separator,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false, -- Remove gaps between terminals
                     screen = awful.screen.preferred,
                     callback = awful.client.setslave,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
    "Steam",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } },
      properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "2" } },
    { rule = { class = "Chromium" },
      properties = { screen = 1, tag = "2" } },
    { rule = { class = "Emacs" },
      properties = { screen = 1, tag = "3" } },

}
-- }}}

-- {{{ Signals


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
    local titlebar = awful.titlebar(c,{
      size=15,
      bg_normal=beautiful.titlebar_bg_normal or "#33333377"
    })
    titlebar: setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
           -- awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
        -- Hide the menubar if we are not floating
   -- local l = awful.layout.get(c.screen)
   -- if not (l.name == "floating" or c.floating) then
   --     awful.titlebar.hide(c)
   -- end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
  local clients = awful.client.visible(s)
  local layout = awful.layout.getname(awful.layout.get(s))

  for _, c in pairs(clients) do
    -- No borders with only one humanly visible client
    if c.maximized then
      -- NOTE: also handled in focus, but that does not cover maximizing from a
      -- tiled state (when the client had focus).
      c.border_width = 0
    elseif c.floating or layout == "floating" then
      c.border_width = beautiful.border_width
    elseif layout == "max" or layout == "fullscreen" then
      c.border_width = 0
    else
      local tiled = awful.client.tiled(c.screen)
      if #tiled == 1 then -- and c == tiled[1] then
        tiled[1].border_width = 0
        -- if layout ~= "max" and layout ~= "fullscreen" then
        -- XXX: SLOW!
        -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
        -- end
      else
        c.border_width = beautiful.border_width
      end
    end
  end
end)
end

-- }}}

client.connect_signal("property::floating", function (c)
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

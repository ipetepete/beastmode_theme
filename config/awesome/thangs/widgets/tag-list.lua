local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local capi = {button = _G.button}
local clickable_container = require('thangs.widgets.clickable-container')
local modkey = require('conf.keys.mod').modKey
local naughty = require('naughty')

--- Common method to create buttons.
-- @tab buttons
-- @param object
-- @treturn table
local function create_buttons(buttons, object)
    if buttons then
        local btns = {}
        for _, b in ipairs(buttons) do
            -- Create a proxy button object: it will receive the real
            -- press and release events, and will propagate them to the
            -- button object the user provided, but with the object as
            -- argument.
            local btn = capi.button {modifiers = b.modifiers, button = b.button}
            btn:connect_signal(
                'press',
                function()
                    b:emit_signal('press', object)
                end
            )
            btn:connect_signal(
                'release',
                function()
                    b:emit_signal('release', object)
                end
            )
            btns[#btns + 1] = btn
        end

        return btns
    end
end

local function list_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            tbm = cache.tbm
            ibm = cache.ibm
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget{
                align  = 'center',
                valign = 'center',
                font = beautiful.taglist_font,
                forced_height = 24,
                forced_width = 24,
                widget = wibox.widget.textbox
            }
            bgb = wibox.container.background()
            tbm = wibox.container.margin(tb, dpi(4), dpi(4))
            ibm = wibox.container.margin(ib, dpi(4), dpi(4), dpi(4), dpi(4))
            l = wibox.layout.fixed.horizontal()
            bg_clickable = clickable_container()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)
            l:add(tbm)
            bg_clickable:set_widget(l)

            -- And all of this gets a background
            bgb:set_widget(bg_clickable)

            bgb:buttons(create_buttons(buttons, o))

            data[o] = {
                ib = ib,
                tb = tb,
                bgb = bgb,
                tbm = tbm,
                ibm = ibm
            }
        end

        local text, bg, bg_image, icon, args = label(o, tb)
        args = args or {}

        -- The text might be invalid, so use pcall.
        if text == nil or text == '' then
            tbm:set_margins(0)
        else
            if not tb:set_markup_silently(text) then
                tb:set_markup('<i>&lt;Invalid text&gt;</i>')
            end
        end
        bgb:set_bg(bg)
        if type(bg_image) == 'function' then
            -- TODO: Why does this pass nil as an argument?
            bg_image = bg_image(tb, o, nil, objects, i)
        end
        bgb:set_bgimage(bg_image)
        if icon == nil then
            ibm:set_margins(0)
        else
            ib.image = icon
        end

        bgb.shape = args.shape
        bgb.shape_border_width = args.shape_border_width
        bgb.shape_border_color = args.shape_border_color

        w:add(bgb)
    end
end

function view_nonempty_tag (offset)
    local tags = awful.screen.focused().tags
    local t = awful.screen.focused().selected_tag
    local i = (t.index - 1 + offset + #tags) % #tags
    -- naughty.notify({text = tostring(#tags)})
    -- naughty.notify({text = tostring(t.index)})
    while i ~= t.index - 1 do
        if #(tags[i + 1]:clients()) > 0 then
            break
        end
        i = (i + offset + #tags) % #tags
    end
    tags[i + 1]:view_only()
end



function viewnext_nonempty_tag (screen)
    view_nonempty_tag(1)
end

function viewprev_nonempty_tag (screen)
    view_nonempty_tag(-1)
end

local TagList = function(s)
    return awful.widget.taglist(
        s,
        awful.widget.taglist.filter.noempty,
        awful.util.table.join(
            awful.button(
                {},
                1,
                function(t)
                    t:view_only()
                end
            ),
            awful.button(
                {modkey},
                1,
                function(t)
                    if _G.client.focus then
                        _G.client.focus:move_to_tag(t)
                        t:view_only()
                    end
                end
            ),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button(
                {modkey},
                3,
                function(t)
                    if _G.client.focus then
                        _G.client.focus:toggle_tag(t)
                    end
                end
            ),
            awful.button(
                {},
                4,
                function(t)
                    viewprev_nonempty_tag(t.screen)
                end
            ),
            awful.button(
                {},
                5,
                function(t)
                    viewnext_nonempty_tag(t.screen)
                end
            )
        ),
        {},
        list_update,
        wibox.layout.fixed.vertical()
    )
end
return TagList

local wibox = require('wibox')
local mat_list_item = require('thangs.widgets.mat-list-item')
local mat_slider = require('thangs.widgets.mat-slider')
local icons = require('thangs.icons')
local watch = require('awful.widget.watch')

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}
local temp_text = wibox.widget.textbox("45")
temp_text.font = "sans 10"
temp_text.forced_width = 12
local max_temp = 80
watch(
  'bash -c "i8kctl temp"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    local temp = stdout:match('(%d+)')
    temp_text.text = temp
    slider:set_value(temp / max_temp * 100)
  end
)

local temperature_meter =
  wibox.widget {
  --[[
  wibox.widget {
    wibox.widget {
      image = icons.thermometer,
      widget = wibox.widget.imagebox
    },
    margins = 12,
    widget = wibox.container.margin
  },
  --]]
  wibox.widget {
    temp_text,
    margins = 12,
    widget = wibox.container.margin
  },
  slider,

  widget = mat_list_item
}

return temperature_meter

local wibox = require('wibox')
local mat_list_item = require('thangs.widgets.mat-list-item')
local mat_slider = require('thangs.widgets.mat-slider')
local icons = require('thangs.icons')
local watch = require('awful.widget.watch')

local total_prev = 0
local idle_prev = 0

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

watch(
  'bash -c "free | grep -z Mem.*Swap.*"',
  1,
  function(widget, stdout, stderr, exitreason, exitcode)
    total,
      used,
      free,
      shared,
      buff_cache,
      available,
      total_swap,
      used_swap,
      free_swap = stdout:match('(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)')
    slider:set_value(used / total * 100)
  end
)

local ram_meter =
  wibox.widget {
  wibox.widget {
    wibox.widget {
      image = icons.memory,
      widget = wibox.widget.imagebox
    },
    margins = 12,
    widget = wibox.container.margin
  },
  slider,
  widget = mat_list_item
}

return ram_meter

local b64 = require('base64')
local utils = require('utils')
local stdout = vim.loop.new_tty(1, false)
local kitty_protocol = {}

local control_data = {
  action = 'a',
  quiet = 'q',
  -- Image transmission controls
  format = 'f',
  medium = 't',
  width = 's',
  height = 'v',
  size = 'S',
  offset = 'O',
  img_id = 'i',
  img_number = 'I',
  placement_id = 'p',
  compression = 'o',
  more_data = 'm',
  -- Image display controls
  img_left_edge = 'x',
  img_top_edge = 'y',
  -- Animation frame loading controls
  anim_left_edge = 'x',
  anim_top_edge = 'y',
  anim_frame_base_num = 'c', -- 1-based
  anim_frame_edit_num = 'r', -- 1-based
  anim_frame_delay = 'z', -- gap between frames in ms (i.e. 16 = 60fps)
  anim_composition = 'X',
  anim_background = 'Y',
  -- Animation frame composition controls
  -- Animation controls
  anim_playback_state = 's',
  anim_playback_curr_frame = 'r',
  anim_playback_frame_delay = 'z',
  anim_playback_next_frame = 'c',
  -- Deleting controls
  delete = 'd'
}

local function get_table_len(t)
  local count = 0
  for _, _ in pairs(t) do
    count = count + 1
  end
  return count
end

kitty_protocol.prepare_file = function(file_name, file_type)
  local control_data = {}
  if file_type == utils.DataType.RGB then
    control_data["f"] = 24
  elseif file_type == utils.DataType.RGBA then
    control_data["f"] = 32
  elseif file_type == utils.DataType.PNG then
    control_data["f"] = 100
  else
    io.write(2, "File type not supported by Kitty protocol. Must be RGB, RGBA, or PNG data")
    return
  end
end

-- Data should come to this function pre-chunked
kitty_protocol.create_graphics_command = function (control_data, payload)
  local esc_char = string.char(27)
  local bs_char = string.char(92)
  local command = esc_char .. "_G"
  local eol = get_table_len(control_data)
  local count = 0
  -- Step through control data table
  for k, v in pairs(control_data) do
    count = count + 1
    command = command .. k .. "=" .. string.lower(v)
    if count ~= eol then
      command = command .. ","
    end
  end
  local bp = b64.encode(payload)
  command = command .. ";" .. bp
  command = command .. esc_char .. bs_char
  return command
end

kitty_protocol.send_to_tty = function(command_string)
  io.write(stdout, command_string)
end

return kitty_protocol

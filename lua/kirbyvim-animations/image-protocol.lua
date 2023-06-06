local terminal = {}
local stdout = vim.loop.new_tty(1, false)

local control_data = {
  --
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
  left_edge = 'x',
  top_edge = 'y',
  -- Animation frame loading controls
  -- Animation frame composition controls
  -- Animation controls
  -- Deleting controls
  delete = 'd'
}

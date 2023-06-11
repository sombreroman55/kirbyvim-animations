-- Base64 implementation in Lua
local base64 = {}

function base64.encode(data)
  local encodings = {}
  local ranges = {{65, 90}, {97, 122}, {48, 57}}

  for _,r in ipairs(ranges) do
    for i = r[1], r[2] do
      encodings[#encodings+1] = string.char(i)
    end
  end
  encodings[#encodings+1] = string.char(43)
  encodings[#encodings+1] = string.char(47)

  local output = ""
  local byteCount = #data
  for i = 1, byteCount, 3 do
    local byte1 = string.byte(data, i)
    local byte2 = string.byte(data, i + 1)
    local byte3 = string.byte(data, i + 2)

    if byte1 and byte2 and byte3 then
      local char1 = encodings[bit.rshift(bit.band(byte1, 0xFC), 2) + 1]
      local char2 = encodings[bit.bor(bit.lshift(bit.band(byte1, 0x03), 4), bit.rshift(bit.band(byte2, 0xF0), 4)) + 1]
      local char3 = encodings[bit.bor(bit.lshift(bit.band(byte2, 0x0F), 2), bit.rshift(bit.band(byte3, 0xC0), 6)) + 1]
      local char4 = encodings[bit.band(byte3, 0x3F) + 1]
      output = output .. char1 .. char2 .. char3 .. char4
    elseif byte1 and byte2 then
      local char1 = encodings[bit.rshift(bit.band(byte1, 0xFC), 2) + 1]
      local char2 = encodings[bit.bor(bit.lshift(bit.band(byte1, 0x03), 4), bit.rshift(bit.band(byte2, 0xF0), 4)) + 1]
      local char3 = encodings[bit.bor(bit.lshift(bit.band(byte2, 0x0F), 2), bit.rshift(bit.band(byte3, 0xC0), 6)) + 1]
      output = output .. char1 .. char2 .. char3 .. "="
    else -- only byte1
      local char1 = encodings[bit.rshift(bit.band(byte1, 0xFC), 2) + 1]
      local char2 = encodings[bit.lshift(bit.band(byte1, 0x03), 4) + 1]
      output = output .. char1 .. char2 .. "=="
    end
  end
  return output
end

return base64

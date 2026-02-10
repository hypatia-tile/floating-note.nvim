local M = {}

local buf_control = require("floating-note.control.buf")
local win_control = require("floating-note.control.window")

local function close_note(win)
  if win ~= -1 and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end

---Toggle the persistemce of floating note.
---@param name string name of the buffer to use
---@param opts table|nil options for the floating window
---@return nil
function M.toggle_note(name, opts)
  local buf = buf_control.get_or_create_buf(name)
  local win = win_control.get_or_open_float(buf, opts)
  local curr_win = vim.api.nvim_get_current_win()
  if curr_win == win then
    -- close the window
    close_note(win)
  else
    -- focus the window
    vim.api.nvim_set_current_win(win)
  end
end

return M

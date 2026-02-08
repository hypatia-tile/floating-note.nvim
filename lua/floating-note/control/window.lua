local M = {}

local layout = require("floating-note.control.layout")

---Open a buffer in a centered floating window with minimal chrome.
---@param buf integer
---@param opts table|nil
---@return integer winid
function M.get_or_open_float(buf, opts)
	-- get bufsize from current window
	local w, h, row, col = layout.layout(opts)
	-- if buffer is already opened in a floating window, return that window id
	if buf == vim.api.nvim_get_current_buf() then
		return vim.api.nvim_get_current_win()
	else
		return vim.api.nvim_open_win(buf, false, {
			relative = "editor",
			width = w,
			height = h,
			row = row,
			col = col,
			style = "minimal",
			border = (opts and opts.border) or "rounded",
			title = (opts and opts.title) or "Notes",
			title_pos = "center",
		})
	end
end

return M

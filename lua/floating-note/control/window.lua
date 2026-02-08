local M = {}

local layout = require("floating-note.control.layout")

---Open a buffer in a centered floating window with minimal chrome.
---@param buf integer
---@param opts table|nil
---@return integer winid
function M.get_or_open_float(buf, opts)
	-- get bufsize from current window
	local w, h, row, col = layout.layout(opts)

	-- Check if buffer is already opened in a floating window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" then
				-- Found the buffer in a floating window, return it
				return win
			end
		end
	end

	-- Buffer not in floating window, create a new one
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

return M

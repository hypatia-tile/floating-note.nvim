local M = {}

M.toggle_note = require("floating-note.control.control").toggle_note

local function get_title()
	local memodir = vim.env.NVIM_FLOATING_MEMO_DIR .. "/diary"
	local fmtdate = os.date("%Y-%m-%d")
	if vim.fn.isdirectory(memodir) == 1 then
		return string.format("%s/%s.md", memodir, fmtdate)
	else
		return string.format("/tmp/floating-note_%s.md", fmtdate)
	end
end

M.setup = function()
	vim.keymap.set("n", "<leader>o", function()
		local memodir = get_title()
		M.toggle_note(memodir, {
			border = "rounded",
			title = "Floating Note",
		})
	end, { noremap = true, silent = true, desc = "Toggle Floating-note" })
end

return M

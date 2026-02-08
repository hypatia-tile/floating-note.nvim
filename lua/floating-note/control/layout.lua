local M = {}

---Dispatch the part of determining floating window layout
---Specify the ratio of the total width/height (0 < x < 1) or the absolute size (x >= 1).
---@param opts table|nil
---@treturn w integer Width of the floating window
---@treturn h integer Height of the floating window
---@treturn col integer Starting row of the floating window
---@treturn row integer Starting column of the floating window
function M.layout(opts)
	opts = opts or {}
	local function size_part(x, total, fallback)
		if type(x) ~= "number" then
			return math.floor(total * fallback)
		end
		if x > 0 and x < 1 then
			return math.floor(total * x)
		end
		return math.floor(x)
	end
	local ui = vim.api.nvim_list_uis()[1]
	local W = (ui and ui.width) or vim.o.columns
	local H = (ui and ui.height) or vim.o.lines
	local w = math.min(size_part(opts.width, W, 0.8), W - 2)
	local h = math.min(size_part(opts.height, H, 0.8), H - 2)
	local col = math.floor((H - h) / 2)
	local row = math.floor((W - w) / 2)
	return w, h, row, col
end

return M

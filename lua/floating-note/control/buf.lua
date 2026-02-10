local M = {}

---Create a nwe buffer with given name
---@param name string Buffer name to create
---@return number bufnr Buffer number of created buffer
local function create_buf(name)
  -- listed = true, scratch = false
  if vim.fn.filewritable(name) == 1 then
    local oldbuf = vim.fn.bufadd(name)
    vim.fn.bufload(oldbuf)
    return oldbuf
  end
  local bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(bufnr, name)
  -- TODO: add buftype if needed
  -- vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].swapfile = false
  return bufnr
end

---Get existing buffer by name or create a new one
---@param name string Buffer name to get or create
---@return number bufnr Buffer number of existing or created buffer
function M.get_or_create_buf(name)
  local bufnr = vim.fn.bufnr(name)
  if bufnr ~= -1 then
    -- If buffer exists, reutrn it
    return bufnr
  else
    -- If buffer does not exist, create a new one
    return create_buf(name)
  end
end

return M

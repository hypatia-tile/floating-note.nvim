local root = vim.fn.getcwd()

local plenary_dir = root .. "/.tests/plenary.nvim"

if not (vim.uv or vim.loop).fs_stat(plenary_dir) then
  local plenary_url = "https://github.com/nvim-lua/plenary.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--depth=1", plenary_url, plenary_dir })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone plenary.nvim: " .. out, vim.log.levels.ERROR)
    os.exit(1)
  end
end

vim.opt.rtp:prepend(root)
vim.opt.rtp:prepend(plenary_dir)

vim.cmd("runtime plugin/plenary.vim")

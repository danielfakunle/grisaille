-- Run with: nvim --headless --clean -l scripts/extras.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())

local files = require('grisaille.extras').render()
for path, content in pairs(files) do
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
  local file = assert(io.open(path, 'wb'))
  assert(file:write(content))
  file:close()
end

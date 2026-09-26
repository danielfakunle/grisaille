local M = {}
local active
local config = {
  transparent = false,
  dim_inactive = false,
  italic_comments = true,
  italic_virtual_text = false,
}

function M.setup(options) config = vim.tbl_extend('force', config, options or {}) end

function M.active()
  if active and vim.g.colors_name == active.name then
    return { temperature = active.temperature, depth = active.depth }
  end
end

function M.load(temperature, depth)
  local colors = require('grisaille.palette').resolve(temperature, depth)
  vim.api.nvim_set_option_value('background', 'dark', {})
  vim.cmd('highlight clear')
  for group, highlight in pairs(require('grisaille.highlights').get(colors, config)) do
    vim.api.nvim_set_hl(0, group, highlight)
  end
  local name = 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
  active = { temperature = temperature, depth = depth, name = name }
  vim.api.nvim_set_var('colors_name', name)
end

return M

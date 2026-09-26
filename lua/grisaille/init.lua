local M = {}
local active

function M.active()
  if active and vim.g.colors_name == active.name then
    return { temperature = active.temperature, depth = active.depth }
  end
end

function M.load(temperature, depth)
  local colors = require('grisaille.palette').resolve(temperature, depth)
  vim.api.nvim_set_option_value('background', 'dark', {})
  vim.cmd('highlight clear')
  vim.api.nvim_set_hl(0, 'Normal', { fg = colors.fg, bg = colors.bg })
  vim.api.nvim_set_hl(0, 'Comment', { fg = colors.comment })
  for _, group in ipairs({ 'Operator', 'Delimiter' }) do
    vim.api.nvim_set_hl(0, group, { fg = colors.dim })
  end
  vim.api.nvim_set_hl(0, 'Statement', { fg = colors.keyword })
  vim.api.nvim_set_hl(0, 'Function', { fg = colors['function'] })
  vim.api.nvim_set_hl(0, 'Constant', { fg = colors.fg })
  vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.fg })
  for _, group in ipairs({ 'String', 'Character', 'Number', 'Boolean', 'Float' }) do
    vim.api.nvim_set_hl(0, group, { fg = colors.literal })
  end
  for _, group in ipairs({ '@property', '@field', '@variable.member', '@variable.parameter' }) do
    vim.api.nvim_set_hl(0, group, { fg = colors.accent })
  end
  vim.api.nvim_set_hl(0, 'Type', { fg = colors.type })
  local name = 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
  active = { temperature = temperature, depth = depth, name = name }
  vim.api.nvim_set_var('colors_name', name)
end

return M

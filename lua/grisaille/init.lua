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
  local palette = require('grisaille.palette')
  local colors = palette.resolve(temperature, depth)
  if config.on_colors then
    local original = vim.deepcopy(colors)
    config.on_colors(colors)
    palette.refresh_derived(colors, original)
  end
  local highlights = require('grisaille.highlights').get(colors, config)
  if config.on_highlights then config.on_highlights(highlights, colors) end
  vim.api.nvim_set_option_value('background', 'dark', {})
  vim.cmd('highlight clear')
  for group, highlight in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, highlight)
  end
  for index = 0, 15 do
    vim.api.nvim_set_var('terminal_color_' .. index, colors['terminal' .. index])
  end
  require('grisaille.lualine').update(colors, config)
  local name = 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
  active = { temperature = temperature, depth = depth, name = name }
  vim.api.nvim_set_var('colors_name', name)
  local lualine = package.loaded.lualine
  if lualine and lualine.get_config and lualine.setup and vim.fn.exists('#lualine#ColorScheme') == 1 then
    local lualine_config = lualine.get_config()
    local theme = lualine_config.options.theme
    if theme == 'auto' or (type(theme) == 'string' and theme:match('^grisaille')) then lualine.setup(lualine_config) end
  end
end

local function switch_axis(axis, value, choices)
  if not vim.tbl_contains(choices, value) then error('Invalid Grisaille ' .. axis .. ': ' .. value) end
  local current = M.active()
  if not current then error('No active Grisaille colorscheme') end
  current[axis] = value
  M.load(current.temperature, current.depth)
end

for _, command in ipairs({
  { name = 'GrisailleVariant', axis = 'temperature', choices = { 'warm', 'balanced', 'cool' } },
  { name = 'GrisailleDepth', axis = 'depth', choices = { 'hard', 'medium', 'soft' } },
}) do
  vim.api.nvim_create_user_command(
    command.name,
    function(args) switch_axis(command.axis, args.args, command.choices) end,
    {
      nargs = 1,
      complete = function(prefix)
        return vim.tbl_filter(function(choice) return vim.startswith(choice, prefix) end, command.choices)
      end,
    }
  )
end

return M

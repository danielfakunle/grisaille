local M = { theme = {} }

local function section(theme, mode, name, fg, bg, bold)
  theme[mode] = theme[mode] or {}
  theme[mode][name] = theme[mode][name] or {}
  local highlight = theme[mode][name]
  highlight.fg = fg
  highlight.bg = bg
  if bold then highlight.gui = 'bold' end
end

function M.update(colors, config)
  local ground = config.transparent and 'NONE' or colors.raised
  local inactive_ground = config.transparent and 'NONE' or colors.line
  local theme = M.theme
  section(theme, 'normal', 'a', colors.deep, colors.accent, true)
  section(theme, 'normal', 'b', colors.fg, ground)
  section(theme, 'normal', 'c', colors.dim, ground)
  for mode, color in pairs({ insert = 'ok', visual = 'info', replace = 'error', command = 'warn', terminal = 'hint' }) do
    section(theme, mode, 'a', colors.deep, colors[color], true)
  end
  for _, name in ipairs({ 'a', 'b', 'c' }) do
    section(theme, 'inactive', name, colors.gutter, inactive_ground)
  end
end

return M

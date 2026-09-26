local M = {}

local grounds = {
  hard = {
    deep = '#0d0d0d',
    bg = '#141414',
    line = '#1c1c1c',
    raised = '#252525',
    border = '#313131',
    edge = '#525252',
    add = '#202515',
    delete = '#301d1b',
    modify = '#12262e',
  },
  medium = {
    deep = '#121212',
    bg = '#1a1a1a',
    line = '#222222',
    raised = '#2c2c2c',
    border = '#383838',
    edge = '#5a5a5a',
    add = '#262c1b',
    delete = '#372321',
    modify = '#182c35',
  },
  soft = {
    deep = '#181818',
    bg = '#202020',
    line = '#282828',
    raised = '#323232',
    border = '#3e3e3e',
    edge = '#616161',
    add = '#2d3221',
    delete = '#3e2a28',
    modify = '#1f333b',
  },
}

local ink = { fg = '#d8d8d8', dim = '#959595', comment = '#696969', gutter = '#484848' }

local pigments = {
  warm = {
    keyword = '#d27789',
    ['function'] = '#fcba81',
    literal = '#95aa6a',
    accent = '#ed9e7d',
    type = '#548fa8',
  },
  balanced = {
    keyword = '#968dcb',
    ['function'] = '#e6c58a',
    literal = '#83ad83',
    accent = '#d8a69f',
    type = '#5290a3',
  },
  cool = {
    keyword = '#a088cb',
    ['function'] = '#e5c493',
    literal = '#81ae81',
    accent = '#74c5bf',
    type = '#5b8abb',
  },
}

local semantic = {
  error = '#ea6b8e',
  warn = '#f0bb3b',
  ok = '#43b16a',
  hint = '#20c9cb',
  info = '#58bdff',
}

local terminal_only = {
  auxiliary = '#a788ca',
  bright_auxiliary = '#b99bde',
  bright_info = '#71d5ff',
}

local terminal_sources = {
  'line',
  'keyword',
  'literal',
  'function',
  'info',
  'auxiliary',
  'type',
  'dim',
  'comment',
  'error',
  'ok',
  'warn',
  'bright_info',
  'bright_auxiliary',
  'hint',
  'fg',
}

local function mix(foreground, background, amount)
  local channels = {}
  for index = 2, 6, 2 do
    local fg = tonumber(foreground:sub(index, index + 1), 16)
    local bg = tonumber(background:sub(index, index + 1), 16)
    channels[#channels + 1] = math.floor(bg + (fg - bg) * amount + 0.5)
  end
  return string.format('#%02x%02x%02x', channels[1], channels[2], channels[3])
end

local function derived(colors)
  local result = { selection = mix(colors.accent, colors.bg, 0.18) }
  for _, role in ipairs({ 'error', 'warn', 'ok', 'hint', 'info' }) do
    result[role .. '_tint'] = mix(colors[role], colors.bg, 0.12)
  end
  for index, source in ipairs(terminal_sources) do
    result['terminal' .. index - 1] = colors[source]
  end
  return result
end

function M.refresh_derived(colors, original)
  for name, value in pairs(derived(colors)) do
    if colors[name] == original[name] then colors[name] = value end
  end
end

function M.resolve(temperature, depth)
  assert(pigments[temperature], 'Invalid Grisaille temperature: ' .. tostring(temperature))
  assert(grounds[depth], 'Invalid Grisaille depth: ' .. tostring(depth))

  local colors = vim.tbl_extend('force', {}, grounds[depth], ink, pigments[temperature], semantic, terminal_only)
  for name, value in pairs(derived(colors)) do
    colors[name] = value
  end
  return colors
end

return M

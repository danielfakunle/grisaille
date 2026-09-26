local expect = MiniTest.expect
local child = require('tests.helpers').new_clean_neovim()

before_each(function() child.setup() end)
teardown(function() child.stop() end)

local temperatures = { 'warm', 'balanced', 'cool' }
local depths = { 'hard', 'medium', 'soft' }

local function name(temperature, depth)
  return 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
end

local function hex(value) return tonumber(value:sub(2), 16) end

local function channels(color) return { math.floor(color / 65536) % 256, math.floor(color / 256) % 256, color % 256 } end

local function linear(value)
  value = value / 255
  return value <= 0.04045 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
end

local function luminance(color)
  local rgb = channels(color)
  return 0.2126 * linear(rgb[1]) + 0.7152 * linear(rgb[2]) + 0.0722 * linear(rgb[3])
end

local function contrast(fg, bg)
  local a, b = luminance(fg), luminance(bg)
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05)
end

local function lightness(color)
  local rgb = channels(color)
  local r, g, b = linear(rgb[1]), linear(rgb[2]), linear(rgb[3])
  local l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ^ (1 / 3)
  local m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ^ (1 / 3)
  local s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ^ (1 / 3)
  return 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
end

local function mixed(fg, bg, amount)
  local f, b = channels(hex(fg)), channels(hex(bg))
  local result = 0
  for i = 1, 3 do
    result = result * 256 + math.floor(b[i] + (f[i] - b[i]) * amount + 0.5)
  end
  return result
end

local function applied(temperature, depth)
  child.cmd('colorscheme ' .. name(temperature, depth))
  local colors = child.lua_get(string.format("require('grisaille.palette').resolve('%s', '%s')", temperature, depth))
  local highlights = child.lua_get([[vim.api.nvim_get_hl(0, {})]])
  return colors, highlights
end

local syntax = {
  fg = { 'Identifier', 'Constant', '@variable', '@constant', '@lsp.type.variable' },
  dim = { 'Operator', 'Delimiter', '@operator', '@punctuation.bracket', '@punctuation.delimiter', '@lsp.type.operator' },
  keyword = { 'Statement', 'Conditional', 'StorageClass', '@keyword.return', '@keyword.import', '@lsp.type.keyword' },
  ['function'] = { 'Function', '@function.call', '@function.method.call', '@lsp.type.function', '@lsp.type.method' },
  literal = {
    'String',
    'Boolean',
    'Number',
    '@string.escape',
    '@constant.builtin',
    '@number',
    '@lsp.type.string',
    '@lsp.type.enumMember',
    '@lsp.type.boolean',
  },
  accent = {
    'Special',
    '@property',
    '@variable.parameter',
    '@variable.member',
    '@lsp.type.parameter',
    '@lsp.type.property',
  },
  type = { 'Type', 'Structure', '@constructor', '@module', '@type', '@lsp.type.class', '@lsp.type.namespace' },
}

describe('code and state roles', function()
  it('maps all three syntax engines without typographic emphasis at every temperature and depth', function()
    for _, temperature in ipairs(temperatures) do
      for _, depth in ipairs(depths) do
        local c, h = applied(temperature, depth)
        for role, groups in pairs(syntax) do
          for _, group in ipairs(groups) do
            expect.equality(h[group].fg, hex(c[role]), name(temperature, depth) .. ': ' .. group)
            expect.equality(h[group].bold, nil)
            expect.equality(h[group].italic, nil)
          end
        end
      end
    end
  end)

  it('uses semantic foregrounds, 12% diagnostic tints and depth-specific diff backgrounds', function()
    for _, temperature in ipairs(temperatures) do
      for _, depth in ipairs(depths) do
        local c, h = applied(temperature, depth)
        for severity, role in pairs({ Error = 'error', Warn = 'warn', Info = 'info', Hint = 'hint', Ok = 'ok' }) do
          expect.equality(h['Diagnostic' .. severity].fg, hex(c[role]))
          expect.equality(h['DiagnosticSign' .. severity].fg, hex(c[role]))
          expect.equality(h['DiagnosticVirtualText' .. severity].fg, hex(c[role]))
          expect.equality(h['DiagnosticVirtualText' .. severity].bg, mixed(c[role], c.bg, 0.12))
          expect.equality(h['DiagnosticLineNr' .. severity].bg, mixed(c[role], c.bg, 0.12))
          expect.equality(h['DiagnosticUnderline' .. severity].sp, hex(c[role]))
          expect.equality(h['DiagnosticUnderline' .. severity].undercurl, true)
        end
        for group, role in pairs({
          Added = 'ok',
          Removed = 'error',
          Changed = 'info',
          diffAdded = 'ok',
          diffRemoved = 'error',
          diffChanged = 'info',
          ['@diff.plus'] = 'ok',
          ['@diff.minus'] = 'error',
          ['@diff.delta'] = 'info',
        }) do
          expect.equality(h[group].fg, hex(c[role]))
        end
        for group, background in pairs({ DiffAdd = 'add', DiffDelete = 'delete', DiffChange = 'modify' }) do
          expect.equality(h[group].bg, hex(c[background]))
        end
        expect.equality(h.Visual.bg, mixed(c.accent, c.bg, 0.18))
        expect.equality(h.Visual.fg, hex(c.fg))
        expect.equality(h.VisualNOS, h.Visual)
        for group, role in pairs({
          ErrorMsg = 'error',
          WarningMsg = 'warn',
          OkMsg = 'ok',
          MoreMsg = 'info',
          Question = 'info',
        }) do
          expect.equality(h[group].fg, hex(c[role]))
        end
        expect.equality(h.Search.bg, hex(c['function']))
        expect.equality(h.IncSearch.bg, hex(c.accent))
      end
    end
  end)

  it('keeps role prominence ordered and stable while semantic colors remain invariant', function()
    local baseline = child.lua_get([[require('grisaille.palette').resolve('balanced', 'hard')]])
    for _, temperature in ipairs(temperatures) do
      for _, depth in ipairs(depths) do
        local c = applied(temperature, depth)
        local order = { 'function', 'accent', 'literal', 'keyword', 'type' }
        for i, role in ipairs(order) do
          expect.equality(math.abs(lightness(hex(c[role])) - lightness(hex(baseline[role]))) < 0.01, true)
          if i > 1 then expect.equality(lightness(hex(c[order[i - 1]])) > lightness(hex(c[role])), true) end
        end
        for _, role in ipairs({ 'error', 'warn', 'ok', 'hint', 'info' }) do
          expect.equality(c[role], baseline[role])
        end
      end
    end
  end)

  it('measures readable foregrounds against their actual rendered backgrounds', function()
    for _, temperature in ipairs(temperatures) do
      for _, depth in ipairs(depths) do
        local c, h = applied(temperature, depth)
        local defined = child.lua_get(
          [[require('grisaille.highlights').get(require('grisaille.palette').resolve(']]
            .. temperature
            .. [[', ']]
            .. depth
            .. [['))]]
        )
        for group, _ in pairs(defined) do
          if
            h[group].fg
            and group ~= 'Comment'
            and group ~= 'SpecialComment'
            and group ~= '@comment'
            and group ~= '@comment.documentation'
            and group ~= '@lsp.type.comment'
          then
            local foreground = h[group].fg
            local background = h[group].bg or h.Normal.bg
            expect.equality(
              contrast(foreground, background) >= 4.49,
              true,
              string.format('%s %s: %.3f', name(temperature, depth), group, contrast(foreground, background))
            )
          end
        end
        -- Comments are deliberately subdued; gutters are decorative.
        for _, group in ipairs({
          'Comment',
          'SpecialComment',
          '@comment',
          '@comment.documentation',
          '@lsp.type.comment',
        }) do
          expect.equality(h[group].fg, hex(c.comment))
          expect.equality(contrast(h[group].fg, h.Normal.bg) >= 2.8, true)
          expect.equality(contrast(h[group].fg, h.Normal.bg) < 4.5, true)
        end
        expect.equality(contrast(hex(c.gutter), h.Normal.bg) < 4.5, true)
      end
    end
  end)
end)

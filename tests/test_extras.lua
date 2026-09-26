local expect = MiniTest.expect
local names = {
  'grisaille',
  'grisaille-medium',
  'grisaille-soft',
  'grisaille-warm',
  'grisaille-warm-medium',
  'grisaille-warm-soft',
  'grisaille-cool',
  'grisaille-cool-medium',
  'grisaille-cool-soft',
}

-- Pinned upstream sources and the exact subset of their supported keys used here:
-- Ghostty v1.2.3 src/config/Config.zig (theme files are config files).
local ghostty_keys = {
  background = true,
  foreground = true,
  ['cursor-color'] = true,
  ['cursor-text'] = true,
  ['selection-background'] = true,
  ['selection-foreground'] = true,
  palette = true,
}
-- OpenCode preset .opencode/themes/mytheme.json at 696f41bc8e7586657375d53390925fc54c25d34c.
local opencode_keys = {
  'primary',
  'secondary',
  'accent',
  'error',
  'warning',
  'success',
  'info',
  'text',
  'textMuted',
  'background',
  'backgroundPanel',
  'backgroundElement',
  'border',
  'borderActive',
  'borderSubtle',
  'diffAdded',
  'diffRemoved',
  'diffContext',
  'diffHunkHeader',
  'diffHighlightAdded',
  'diffHighlightRemoved',
  'diffAddedBg',
  'diffRemovedBg',
  'diffContextBg',
  'diffLineNumber',
  'diffAddedLineNumberBg',
  'diffRemovedLineNumberBg',
  'markdownText',
  'markdownHeading',
  'markdownLink',
  'markdownLinkText',
  'markdownCode',
  'markdownBlockQuote',
  'markdownEmph',
  'markdownStrong',
  'markdownHorizontalRule',
  'markdownListItem',
  'markdownListEnumeration',
  'markdownImage',
  'markdownImageText',
  'markdownCodeBlock',
  'syntaxComment',
  'syntaxKeyword',
  'syntaxFunction',
  'syntaxVariable',
  'syntaxString',
  'syntaxNumber',
  'syntaxType',
  'syntaxOperator',
  'syntaxPunctuation',
}
-- Bat v0.25.0 uses Sublime Text .tmTheme plist (README.md#adding-new-themes).
-- Global keys are pinned to syntect v5.2.0 src/highlighting/theme.rs ThemeSettings,
-- which Bat consumes. The plist's scope/settings dictionaries are ThemeItems.
local bat_global = {
  background = true,
  foreground = true,
  caret = true,
  lineHighlight = true,
  selection = true,
  gutterForeground = true,
}

local function contents(path)
  local file = assert(io.open(path, 'rb'))
  local result = file:read('*a')
  file:close()
  return result
end

local function palette(name)
  local temperature = name:match('grisaille%-(warm)') or name:match('grisaille%-(cool)') or 'balanced'
  local depth = name:match('%-(medium)$') or name:match('%-(soft)$') or 'hard'
  return require('grisaille.palette').resolve(temperature, depth)
end

describe('installed companion themes', function()
  it('renders all nine names in each format with committed bytes', function()
    local rendered = require('grisaille.extras').render()
    local count = 0
    for path, bytes in pairs(rendered) do
      count = count + 1
      expect.equality(contents(path), bytes, path)
    end
    expect.equality(count, 27)
    for _, format in ipairs({ 'bat', 'ghostty', 'opencode' }) do
      local extension = format == 'bat' and '.tmTheme' or format == 'opencode' and '.json' or ''
      local actual = vim.fn.glob('extras/' .. format .. '/*', false, true)
      expect.equality(#actual, 9)
      for _, name in ipairs(names) do
        expect.equality(type(rendered['extras/' .. format .. '/' .. name .. extension]), 'string')
      end
    end
  end)

  it('uses only palette colors and supported Ghostty keys, including all ANSI slots', function()
    for _, name in ipairs(names) do
      local colors = palette(name)
      local valid = {}
      for _, color in pairs(colors) do
        valid[color] = true
      end
      local values, slots, keys = {}, {}, {}
      for line in contents('extras/ghostty/' .. name):gmatch('[^\n]+') do
        if not line:match('^#') and line ~= '' then
          local key, value = line:match('^([%w%-]+) = (.+)$')
          expect.equality(ghostty_keys[key], true, line)
          keys[key] = true
          if key == 'palette' then
            local index
            index, value = value:match('^(%d+)=(#[%da-f]+)$')
            expect.equality(index ~= nil, true)
            expect.equality(slots[index], nil)
            slots[index] = value
          else
            expect.equality(values[key], nil)
            values[key] = value
          end
          expect.equality(valid[value], true, line)
        end
      end
      expect.equality(vim.tbl_count(keys), vim.tbl_count(ghostty_keys))
      expect.equality(vim.tbl_count(slots), 16)
      for index = 0, 15 do
        expect.equality(slots[tostring(index)], colors['terminal' .. index])
      end
      expect.equality(values.background, colors.bg)
      expect.equality(values['selection-background'], colors.selection)
    end
  end)

  it('uses the pinned OpenCode theme keys and palette references without retired keys', function()
    local allowed = {}
    for _, key in ipairs(opencode_keys) do
      allowed[key] = true
    end
    for _, name in ipairs(names) do
      local document = vim.json.decode(contents('extras/opencode/' .. name .. '.json'))
      expect.equality(document['$schema'], 'https://opencode.ai/theme.json')
      expect.equality(vim.tbl_count(document), 3)
      expect.equality(vim.tbl_count(document.theme), #opencode_keys)
      local colors = palette(name)
      for key, role in pairs(document.theme) do
        expect.equality(allowed[key], true, key)
        expect.equality(type(role), 'string')
        expect.equality(document.defs[role], colors[role], key)
      end
      for role, value in pairs(document.defs) do
        expect.equality(colors[role], value, role)
      end
      expect.equality(document.theme.background, 'bg')
      expect.equality(document.theme.syntaxFunction, 'function')
      expect.equality(document.theme.syntaxVariable, 'fg')
    end
  end)

  it('emits named Bat plist themes with palette-backed global and scoped colors', function()
    for _, name in ipairs(names) do
      local xml = contents('extras/bat/' .. name .. '.tmTheme')
      expect.equality(xml:match('<key>name</key>%s*<string>(.-)</string>'), name)
      expect.equality(xml:match('^<%?xml') ~= nil, true)
      local allowed = {}
      for _, color in pairs(palette(name)) do
        allowed[color] = true
      end
      for value in xml:gmatch('<string>(#[%da-f]+)</string>') do
        expect.equality(allowed[value], true, value)
      end
      for key in xml:gmatch('<key>(.-)</key>') do
        expect.equality(
          ({
            name = true,
            settings = true,
            scope = true,
            foreground = true,
            fontStyle = true,
            background = true,
            caret = true,
            lineHighlight = true,
            selection = true,
            gutterForeground = true,
          })[key],
          true,
          key
        )
      end
      for key in pairs(bat_global) do
        expect.equality(xml:find('<key>' .. key .. '</key>', 1, true) ~= nil, true)
      end
      for _, scope in ipairs({
        'comment',
        'keyword',
        'entity.name.function',
        'constant.numeric',
        'entity.name.type',
        'variable',
        'markup.inserted',
        'markup.deleted',
      }) do
        expect.equality(xml:find(scope, 1, true) ~= nil, true, scope)
      end
      expect.equality(
        xml:match(
          '<string>constant.character.escape, string.regexp</string>.-<key>foreground</key>%s*<string>(#[%da-f]+)</string>'
        ),
        palette(name).literal
      )
    end
  end)
end)

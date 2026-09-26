local expect = MiniTest.expect
local child = require('tests.helpers').new_clean_neovim()

before_each(function() child.setup() end)

teardown(function() child.stop() end)

local function theme_name(temperature, depth)
  return 'grisaille'
    .. (temperature == 'balanced' and '' or '-' .. temperature)
    .. (depth == 'hard' and '' or '-' .. depth)
end

describe('public colorschemes', function()
  it('applies color and highlight callbacks in order to editor, terminal, and lualine', function()
    child.lua([[
      callback_events = {}
      require('grisaille').setup({
        on_colors = function(colors)
          table.insert(callback_events, 'colors')
          colors.accent = '#abcdef'
          colors.terminal1 = '#123456'
        end,
        on_highlights = function(highlights, colors)
          table.insert(callback_events, 'highlights:' .. colors.accent)
          highlights.Normal.fg = colors.accent
          highlights.CustomGrisaille = { fg = colors.accent }
        end,
      })
    ]])
    child.cmd('colorscheme grisaille')
    expect.equality(child.lua_get('callback_events'), { 'colors', 'highlights:#abcdef' })
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Normal" }).fg'), 0xabcdef)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "CustomGrisaille" }).fg'), 0xabcdef)
    expect.equality(child.lua_get('vim.g.terminal_color_1'), '#123456')
    expect.equality(child.lua_get("require('lualine.themes.grisaille').normal.a.bg"), '#abcdef')
  end)

  it('propagates adjusted roles to derived colors unless explicitly customized', function()
    child.lua([[
      require('grisaille').setup({
        on_colors = function(colors)
          colors.accent = '#ffffff'
          colors.keyword = '#ffffff'
          colors.error = '#ffffff'
          colors.terminal1 = '#123456'
        end,
      })
    ]])
    child.cmd('colorscheme grisaille')
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Visual" }).bg'), 0x3e3e3e)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }).bg'), 0x303030)
    expect.equality(child.lua_get('vim.g.terminal_color_1'), '#123456')
    expect.equality(child.lua_get('vim.g.terminal_color_9'), '#ffffff')
    expect.equality(child.lua_get("require('lualine.themes.grisaille').normal.a.bg"), '#ffffff')
  end)

  it('switches either axis from every starting pair and reapplies customization', function()
    child.lua([[
      vim.opt.runtimepath:append(vim.fn.getcwd() .. '/deps/lualine.nvim')
      callback_events = {}
      require('grisaille').setup({
        on_colors = function(colors)
          table.insert(callback_events, { step = 'colors', original = colors.accent })
          colors.accent = '#abcdef'
          colors.terminal1 = '#123456'
        end,
        on_highlights = function(highlights, colors)
          table.insert(callback_events, { step = 'highlights', adjusted = colors.accent })
          highlights.Normal.fg = colors.accent
        end,
      })
    ]])
    local temperatures = { 'warm', 'balanced', 'cool' }
    local depths = { 'hard', 'medium', 'soft' }
    local backgrounds = { hard = 0x141414, medium = 0x1a1a1a, soft = 0x202020 }
    local function expect_switched_theme(temperature, depth, callback_count)
      expect.equality(child.lua_get('require("grisaille").active()'), { temperature = temperature, depth = depth })
      expect.equality(child.lua_get('vim.g.colors_name'), theme_name(temperature, depth))
      expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Normal" }).bg'), backgrounds[depth])
      expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Normal" }).fg'), 0xabcdef)
      expect.equality(child.lua_get('vim.g.terminal_color_1'), '#123456')
      expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_a_normal" }).bg'), 0xabcdef)
      expect.equality(child.lua_get('#callback_events'), callback_count)
      expect.equality(child.lua_get('callback_events[#callback_events - 1].original ~= "#abcdef"'), true)
      expect.equality(child.lua_get('callback_events[#callback_events].adjusted'), '#abcdef')
    end
    for _, temperature in ipairs(temperatures) do
      for _, depth in ipairs(depths) do
        child.cmd('colorscheme ' .. theme_name(temperature, depth))
        child.lua([[require('lualine').setup({ options = { theme = 'auto' } })]])
        local count = child.lua_get('#callback_events')
        local next_temperature = temperature == 'warm' and 'cool' or 'warm'
        child.cmd('GrisailleVariant ' .. next_temperature)
        expect_switched_theme(next_temperature, depth, count + 2)
        local next_depth = depth == 'hard' and 'soft' or 'hard'
        child.cmd('GrisailleDepth ' .. next_depth)
        expect_switched_theme(next_temperature, next_depth, count + 4)
      end
    end
  end)

  it('completes both command axes', function()
    child.cmd('colorscheme grisaille')
    expect.equality(
      child.lua_get("vim.fn.getcompletion('GrisailleVariant ', 'cmdline')"),
      { 'warm', 'balanced', 'cool' }
    )
    expect.equality(child.lua_get("vim.fn.getcompletion('GrisailleDepth ', 'cmdline')"), { 'hard', 'medium', 'soft' })
  end)

  it('rejects invalid commands without mutating the active theme or callbacks', function()
    child.lua([[
      vim.opt.runtimepath:append(vim.fn.getcwd() .. '/deps/lualine.nvim')
      callback_count = 0
      require('grisaille').setup({
        on_colors = function(colors)
          callback_count = callback_count + 1
          colors.accent = '#abcdef'
          colors.terminal1 = '#123456'
        end,
      })
      function theme_snapshot()
        local terminals = {}
        for index = 0, 15 do terminals[index + 1] = vim.g['terminal_color_' .. index] end
        return {
          pair = require('grisaille').active(),
          name = vim.g.colors_name,
          background = vim.o.background,
          highlights = vim.api.nvim_get_hl(0, {}),
          terminals = terminals,
          lualine_theme = vim.deepcopy(require('lualine.themes.grisaille')),
          lualine_highlight = vim.api.nvim_get_hl(0, { name = 'lualine_a_normal' }),
          callback_count = callback_count,
        }
      end
    ]])
    for _, temperature in ipairs({ 'warm', 'balanced', 'cool' }) do
      for _, depth in ipairs({ 'hard', 'medium', 'soft' }) do
        child.cmd('colorscheme ' .. theme_name(temperature, depth))
        child.lua([[require('lualine').setup({ options = { theme = 'auto' } })]])
        local before = child.lua_get('theme_snapshot()')
        for _, command in ipairs({ 'GrisailleVariant icy', 'GrisailleDepth shallow' }) do
          local result = child.lua_get(string.format(
            [[(function()
            local ok, err = pcall(vim.cmd, %q)
            return { ok = ok, error = tostring(err) }
          end)()]],
            command
          ))
          expect.equality(result.ok, false)
          expect.equality(result.error:find('Invalid Grisaille', 1, true) ~= nil, true)
          expect.equality(child.lua_get('theme_snapshot()'), before)
        end
      end
    end
  end)

  it('loads Balanced Hard by its canonical name', function()
    child.cmd('colorscheme grisaille')
    expect.equality(child.lua_get('vim.g.colors_name'), 'grisaille')
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Normal" }).bg'), 0x141414)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Identifier" }).fg'), 0xd8d8d8)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Constant" }).fg'), 0xd8d8d8)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "String" }).fg'), 0x83ad83)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Comment" }).fg'), 0x696969)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Operator" }).fg'), 0x959595)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Delimiter" }).fg'), 0x959595)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "@property" }).fg'), 0xd8a69f)
  end)

  it('resolves a fresh complete Balanced Hard palette with terminal aliases and tints', function()
    local colors = child.lua_get([[require('grisaille.palette').resolve('balanced', 'hard')]])
    expect.equality(colors, {
      deep = '#0d0d0d',
      bg = '#141414',
      line = '#1c1c1c',
      raised = '#252525',
      border = '#313131',
      edge = '#525252',
      add = '#202515',
      delete = '#301d1b',
      modify = '#12262e',
      fg = '#d8d8d8',
      dim = '#959595',
      comment = '#696969',
      gutter = '#484848',
      keyword = '#968dcb',
      ['function'] = '#e6c58a',
      literal = '#83ad83',
      accent = '#d8a69f',
      type = '#5290a3',
      error = '#ea6b8e',
      warn = '#f0bb3b',
      ok = '#43b16a',
      hint = '#20c9cb',
      info = '#58bdff',
      auxiliary = '#a788ca',
      bright_auxiliary = '#b99bde',
      bright_info = '#71d5ff',
      selection = '#372e2d',
      error_tint = '#2e1e23',
      warn_tint = '#2e2819',
      ok_tint = '#1a271e',
      hint_tint = '#152a2a',
      info_tint = '#1c2830',
      terminal0 = '#1c1c1c',
      terminal1 = '#968dcb',
      terminal2 = '#83ad83',
      terminal3 = '#e6c58a',
      terminal4 = '#58bdff',
      terminal5 = '#a788ca',
      terminal6 = '#5290a3',
      terminal7 = '#959595',
      terminal8 = '#696969',
      terminal9 = '#ea6b8e',
      terminal10 = '#43b16a',
      terminal11 = '#f0bb3b',
      terminal12 = '#71d5ff',
      terminal13 = '#b99bde',
      terminal14 = '#20c9cb',
      terminal15 = '#d8d8d8',
    })
    child.lua([[local c = require('grisaille.palette').resolve('balanced', 'hard'); c.bg = '#ffffff']])
    expect.equality(child.lua_get([[require('grisaille.palette').resolve('balanced', 'hard').bg]]), '#141414')
  end)

  it('loads each named temperature and depth with its own applied palette', function()
    local cases = {
      { name = 'grisaille', temperature = 'balanced', depth = 'hard', bg = '#141414', keyword = '#968dcb' },
      { name = 'grisaille-medium', temperature = 'balanced', depth = 'medium', bg = '#1a1a1a', keyword = '#968dcb' },
      { name = 'grisaille-soft', temperature = 'balanced', depth = 'soft', bg = '#202020', keyword = '#968dcb' },
      { name = 'grisaille-warm', temperature = 'warm', depth = 'hard', bg = '#141414', keyword = '#d27789' },
      { name = 'grisaille-warm-medium', temperature = 'warm', depth = 'medium', bg = '#1a1a1a', keyword = '#d27789' },
      { name = 'grisaille-warm-soft', temperature = 'warm', depth = 'soft', bg = '#202020', keyword = '#d27789' },
      { name = 'grisaille-cool', temperature = 'cool', depth = 'hard', bg = '#141414', keyword = '#a088cb' },
      { name = 'grisaille-cool-medium', temperature = 'cool', depth = 'medium', bg = '#1a1a1a', keyword = '#a088cb' },
      { name = 'grisaille-cool-soft', temperature = 'cool', depth = 'soft', bg = '#202020', keyword = '#a088cb' },
    }
    for _, case in ipairs(cases) do
      child.cmd('colorscheme ' .. case.name)
      expect.equality(child.lua_get('vim.g.colors_name'), case.name)
      expect.equality(
        child.lua_get('require("grisaille").active()'),
        { temperature = case.temperature, depth = case.depth }
      )
      expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "Normal" }).bg'), tonumber(case.bg:sub(2), 16))
      expect.equality(
        child.lua_get('vim.api.nvim_get_hl(0, { name = "Statement" }).fg'),
        tonumber(case.keyword:sub(2), 16)
      )
      local colors =
        child.lua_get(string.format("require('grisaille.palette').resolve('%s', '%s')", case.temperature, case.depth))
      expect.equality(colors.bg, case.bg)
      expect.equality(colors.keyword, case.keyword)
      expect.equality(colors.fg, '#d8d8d8')
      expect.equality(colors.error, '#ea6b8e')
    end
  end)

  it('exports all ANSI slots without using terminal-only colors in editor highlights', function()
    local grounds = { hard = '#1c1c1c', medium = '#222222', soft = '#282828' }
    local pigments = {
      warm = { '#d27789', '#95aa6a', '#fcba81', '#548fa8' },
      balanced = { '#968dcb', '#83ad83', '#e6c58a', '#5290a3' },
      cool = { '#a088cb', '#81ae81', '#e5c493', '#5b8abb' },
    }
    for temperature, colors in pairs(pigments) do
      for depth, line in pairs(grounds) do
        local name = theme_name(temperature, depth)
        child.cmd('colorscheme ' .. name)
        local actual = child.lua_get([[(function()
          local slots = {}
          for index = 0, 15 do slots[index + 1] = vim.g['terminal_color_' .. index] end
          return slots
        end)()]])
        expect.equality(actual, {
          line,
          colors[1],
          colors[2],
          colors[3],
          '#58bdff',
          '#a788ca',
          colors[4],
          '#959595',
          '#696969',
          '#ea6b8e',
          '#43b16a',
          '#f0bb3b',
          '#71d5ff',
          '#b99bde',
          '#20c9cb',
          '#d8d8d8',
        })
        local highlights = child.lua_get('vim.api.nvim_get_hl(0, {})')
        for _, highlight in pairs(highlights) do
          for _, value in pairs(highlight) do
            if type(value) == 'number' then
              expect.equality(value ~= 0xa788ca and value ~= 0xb99bde and value ~= 0x71d5ff, true)
            end
          end
        end
      end
    end
  end)

  it('serves the active resolved palette to lualine for every named theme', function()
    local grounds = {
      hard = { deep = '#0d0d0d', raised = '#252525', line = '#1c1c1c' },
      medium = { deep = '#121212', raised = '#2c2c2c', line = '#222222' },
      soft = { deep = '#181818', raised = '#323232', line = '#282828' },
    }
    local accents = { warm = '#ed9e7d', balanced = '#d8a69f', cool = '#74c5bf' }
    for temperature, accent in pairs(accents) do
      for depth, ground in pairs(grounds) do
        local name = theme_name(temperature, depth)
        child.cmd('colorscheme ' .. name)
        local theme = child.lua_get(string.format("require('lualine.themes.%s')", name))
        expect.equality(theme.normal.a, { fg = ground.deep, bg = accent, gui = 'bold' })
        expect.equality(theme.normal.b, { fg = '#d8d8d8', bg = ground.raised })
        expect.equality(theme.normal.c, { fg = '#959595', bg = ground.raised })
        expect.equality(theme.insert.a, { fg = ground.deep, bg = '#43b16a', gui = 'bold' })
        expect.equality(theme.visual.a, { fg = ground.deep, bg = '#58bdff', gui = 'bold' })
        expect.equality(theme.replace.a, { fg = ground.deep, bg = '#ea6b8e', gui = 'bold' })
        expect.equality(theme.command.a, { fg = ground.deep, bg = '#f0bb3b', gui = 'bold' })
        expect.equality(theme.terminal.a, { fg = ground.deep, bg = '#20c9cb', gui = 'bold' })
        expect.equality(theme.inactive, {
          a = { fg = '#484848', bg = ground.line },
          b = { fg = '#484848', bg = ground.line },
          c = { fg = '#484848', bg = ground.line },
        })
      end
    end
  end)

  it('renders lualine highlights from each publicly loaded palette and refreshes on direct load', function()
    child.lua([[
      vim.opt.runtimepath:append(vim.fn.getcwd() .. '/deps/lualine.nvim')
    ]])
    child.cmd('colorscheme grisaille')
    child.lua([[require('lualine').setup({ options = { theme = 'auto' } })]])
    local grounds = {
      hard = { deep = 0x0d0d0d, raised = 0x252525 },
      medium = { deep = 0x121212, raised = 0x2c2c2c },
      soft = { deep = 0x181818, raised = 0x323232 },
    }
    local accents = { warm = 0xed9e7d, balanced = 0xd8a69f, cool = 0x74c5bf }
    for temperature, accent in pairs(accents) do
      for depth, ground in pairs(grounds) do
        child.cmd('colorscheme ' .. theme_name(temperature, depth))
        expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })').bg, accent)
        expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })').fg, ground.deep)
        expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_b_normal" })').bg, ground.raised)
        expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_a_insert" })').bg, 0x43b16a)
        local statusline = child.lua_get([[require('lualine').statusline(true)]])
        expect.equality(statusline:find('%#lualine_a_normal#', 1, true) ~= nil, true)
      end
    end
    child.lua([[require('grisaille').load('warm', 'medium')]])
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })').bg, 0xed9e7d)
    expect.equality(child.lua_get('vim.api.nvim_get_hl(0, { name = "lualine_b_normal" })').bg, 0x2c2c2c)
  end)

  it('updates an already loaded lualine theme when the colorscheme changes', function()
    child.cmd('colorscheme grisaille')
    child.lua([[
      cached_theme = require('lualine.themes.grisaille')
      cached_section = cached_theme.normal.a
      package.loaded.lualine = {
        get_config = function() return { options = { theme = 'auto' } } end,
        setup = function(config)
          refreshed_theme = require('lualine.themes.' .. vim.g.colors_name).normal.a.bg
          refreshed_config = config
        end,
      }
      vim.api.nvim_create_autocmd('ColorScheme', { group = vim.api.nvim_create_augroup('lualine', {}), callback = function() end })
    ]])
    child.cmd('colorscheme grisaille-cool-soft')
    expect.equality(child.lua_get('cached_theme.normal.a.bg'), '#74c5bf')
    expect.equality(child.lua_get('cached_section.bg'), '#74c5bf')
    expect.equality(child.lua_get('cached_theme.normal.b.bg'), '#323232')
    expect.equality(child.lua_get('cached_theme.insert.a.fg'), '#181818')
    expect.equality(child.lua_get('refreshed_theme'), '#74c5bf')
    expect.equality(child.lua_get('refreshed_config'), { options = { theme = 'auto' } })
  end)

  it('does not initialize lualine merely because its module was loaded', function()
    child.lua([[
      package.loaded.lualine = {
        get_config = function() return {} end,
        setup = function() error('lualine was not configured') end,
      }
    ]])
    child.cmd('colorscheme grisaille')
  end)

  it('does not reconfigure an unrelated lualine theme', function()
    child.lua([[
      package.loaded.lualine = {
        get_config = function() return { options = { theme = 'other-theme' } } end,
        setup = function() error('unrelated lualine theme was reconfigured') end,
      }
      vim.api.nvim_create_autocmd('ColorScheme', { group = vim.api.nvim_create_augroup('lualine', {}), callback = function() end })
    ]])
    child.cmd('colorscheme grisaille-warm')
  end)

  it('changes only syntax pigments with temperature and ground with depth', function()
    local ground = {
      hard = { '#0d0d0d', '#141414', '#1c1c1c', '#252525', '#313131', '#525252', '#202515', '#301d1b', '#12262e' },
      medium = { '#121212', '#1a1a1a', '#222222', '#2c2c2c', '#383838', '#5a5a5a', '#262c1b', '#372321', '#182c35' },
      soft = { '#181818', '#202020', '#282828', '#323232', '#3e3e3e', '#616161', '#2d3221', '#3e2a28', '#1f333b' },
    }
    local pigments = {
      warm = { '#d27789', '#fcba81', '#95aa6a', '#ed9e7d', '#548fa8' },
      balanced = { '#968dcb', '#e6c58a', '#83ad83', '#d8a69f', '#5290a3' },
      cool = { '#a088cb', '#e5c493', '#81ae81', '#74c5bf', '#5b8abb' },
    }
    local ground_keys = { 'deep', 'bg', 'line', 'raised', 'border', 'edge', 'add', 'delete', 'modify' }
    local pigment_keys = { 'keyword', 'function', 'literal', 'accent', 'type' }
    local reference = child.lua_get([[require('grisaille.palette').resolve('balanced', 'hard')]])
    for temperature, expected_pigments in pairs(pigments) do
      for depth, expected_ground in pairs(ground) do
        local colors =
          child.lua_get(string.format("require('grisaille.palette').resolve('%s', '%s')", temperature, depth))
        for index, key in ipairs(ground_keys) do
          expect.equality(colors[key], expected_ground[index])
        end
        for index, key in ipairs(pigment_keys) do
          expect.equality(colors[key], expected_pigments[index])
        end
        for _, key in ipairs({ 'fg', 'dim', 'comment', 'gutter', 'error', 'warn', 'ok', 'hint', 'info' }) do
          expect.equality(colors[key], reference[key])
        end
        expect.equality(vim.tbl_count(colors), vim.tbl_count(reference))
      end
    end
  end)

  it('does not report Grisaille as active after another colorscheme loads', function()
    child.cmd('colorscheme grisaille-warm')
    child.cmd('colorscheme default')
    expect.equality(child.lua_get('require("grisaille").active()'), vim.NIL)
  end)
end)

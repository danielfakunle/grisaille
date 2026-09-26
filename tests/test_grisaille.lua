local expect = MiniTest.expect
local child = require('tests.helpers').new_clean_neovim()

before_each(function() child.setup() end)

teardown(function() child.stop() end)

describe('public colorschemes', function()
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

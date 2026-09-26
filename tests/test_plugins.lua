local expect = MiniTest.expect
local child = require('tests.helpers').new_clean_neovim()

before_each(function() child.setup() end)
teardown(function() child.stop() end)

local function hex(color) return tonumber(color:sub(2), 16) end

local function applied(theme, temperature, depth)
  child.cmd('colorscheme ' .. theme)
  local highlights = child.lua_get('vim.api.nvim_get_hl(0, {})')
  if temperature then
    return highlights,
      child.lua_get(string.format("require('grisaille.palette').resolve('%s', '%s')", temperature, depth))
  end
  return highlights
end

describe('plugin integrations through public colorschemes', function()
  it('links plugin windows to shared surfaces in painted and transparent mode', function()
    for _, transparent in ipairs({ false, true }) do
      child.lua('require("grisaille").setup({ transparent = ' .. tostring(transparent) .. ' })')
      local h = applied('grisaille-medium')
      for _, group in ipairs({
        'SnacksNormal',
        'SnacksNormalNC',
        'FzfLuaNormal',
        'WhichKeyNormal',
        'NoiceCmdlinePopup',
        'TroubleNormal',
        'LazyNormal',
        'MasonNormal',
        'DapUINormal',
        'NeotestSummary',
        'MiniPickNormal',
        'GrugFarNormal',
        'NeoTreeNormal',
        'NvimTreeNormal',
        'DiffviewNormal',
        'MiniMapNormal',
        'NoiceMini',
      }) do
        expect.equality(h[group].link, 'NormalFloat', group)
      end
      for _, group in ipairs({
        'FzfLuaBorder',
        'WhichKeyBorder',
        'NoiceCmdlinePopupBorder',
        'DapUIFloatBorder',
        'MiniPickBorder',
        'NeoTreeFloatBorder',
        'NoiceConfirmBorder',
      }) do
        expect.equality(h[group].link, 'FloatBorder', group)
      end
      expect.equality(h.NormalFloat.bg == nil, transparent)
      expect.equality(h.FloatBorder.bg == nil, transparent)
    end
  end)

  it('keeps blink completion surfaces painted and maps completion kinds to syntax roles', function()
    child.lua([[require('grisaille').setup({ transparent = true })]])
    for _, variant in ipairs({ { 'grisaille-warm', 'warm', 'hard' }, { 'grisaille-cool-soft', 'cool', 'soft' } }) do
      local h, c = applied(variant[1], variant[2], variant[3])
      for _, group in ipairs({ 'BlinkCmpMenu', 'BlinkCmpDoc', 'BlinkCmpSignatureHelp' }) do
        expect.equality(h[group].bg, hex(c.deep), group)
      end
      expect.equality(h.BlinkCmpMenuSelection.bg, hex(c.raised))
      expect.equality(h.BlinkCmpKindFunction.fg, hex(c['function']))
      expect.equality(h.BlinkCmpKindVariable.fg, hex(c.fg))
      expect.equality(h.BlinkCmpKindClass.fg, hex(c.type))
      expect.equality(h.BlinkCmpKindProperty.fg, hex(c.accent))
      expect.equality(h.BlinkCmpLabelMatch.fg, hex(c.accent))
    end
  end)

  it('keeps git, diagnostic, and development state semantic across temperatures and depths', function()
    local indicators = {
      ok = {
        'GitSignsAdd',
        'NeoTreeGitAdded',
        'NvimTreeGitNew',
        'MiniDiffSignAdd',
        'DiffviewStatusAdded',
        'NeotestPassed',
        'DapUIWatchesValue',
        'GrugFarResultsMatchAdded',
        'GrugFarResultsAddIndicator',
      },
      info = {
        'GitSignsChange',
        'NeoTreeGitModified',
        'NvimTreeGitDirty',
        'MiniDiffSignChange',
        'DiffviewStatusModified',
        'DapLogPoint',
        'SnacksNotifierInfo',
        'GrugFarResultsChangeIndicator',
        'DapUIModifiedValue',
      },
      error = {
        'GitSignsDelete',
        'NeoTreeGitDeleted',
        'NvimTreeGitDeleted',
        'MiniDiffSignDelete',
        'DiffviewStatusDeleted',
        'NeotestFailed',
        'DapBreakpoint',
        'GrugFarResultsMatchRemoved',
        'GrugFarResultsRemoveIndicator',
      },
      warn = { 'NeotestRunning', 'DapStopped', 'DapUIStoppedThread', 'SnacksNotifierWarn' },
      hint = { 'NoiceLspProgressSpinner' },
    }
    for _, variant in ipairs({
      { 'grisaille-warm', 'warm', 'hard' },
      { 'grisaille', 'balanced', 'hard' },
      { 'grisaille-cool-soft', 'cool', 'soft' },
    }) do
      local h, c = applied(variant[1], variant[2], variant[3])
      for role, names in pairs(indicators) do
        for _, group in ipairs(names) do
          expect.equality(h[group].fg, hex(c[role]), variant[1] .. ': ' .. group)
        end
      end
      expect.equality(h.GitSignsAddLn.bg, hex(c.add))
      expect.equality(h.GitSignsDeleteLn.bg, hex(c.delete))
      expect.equality(h.GitSignsChangeLn.bg, hex(c.modify))
    end
  end)

  it('styles navigation, search, structure, and plugin-specific UI without pinning window grounds', function()
    local h, c = applied('grisaille-cool-medium', 'cool', 'medium')
    for group, role in pairs({
      SnacksPickerMatch = 'accent',
      FzfLuaFzfMatch = 'accent',
      WhichKey = 'accent',
      NeoTreeDirectoryName = 'type',
      NvimTreeFolderName = 'type',
      netrwDir = 'type',
      TroubleFile = 'type',
      FlashBackdrop = 'dim',
      LazyH2 = 'accent',
      MasonHighlight = 'type',
      DapUIScope = 'type',
      NeotestNamespace = 'type',
      MiniPickMatchRanges = 'accent',
      HLLineNum1 = 'accent',
      GrugFarResultsPath = 'type',
      DiffviewFilePanelTitle = 'accent',
      TreesitterContextLineNumber = 'gutter',
      GrugFarResultsLineNr = 'gutter',
      RainbowDelimiterRed = 'keyword',
      RainbowDelimiterYellow = 'function',
      RainbowDelimiterGreen = 'literal',
      RainbowDelimiterCyan = 'type',
      RainbowDelimiterOrange = 'accent',
    }) do
      expect.equality(h[group].fg, hex(c[role]), group)
    end
    expect.equality(h.FlashLabel.fg, hex(c.bg))
    expect.equality(h.FlashLabel.bg, hex(c.accent))
    expect.equality(h.IlluminatedWordText.bg, hex(c.raised))
    expect.equality(h.TreesitterContext.bg, hex(c.line))
    expect.equality(h.HLChunk1.fg, hex(c.edge))
  end)
end)

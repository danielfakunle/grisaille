local M = {}

function M.get(c, config)
  local groups = {}
  for _, name in ipairs({
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
    'NeoTreeNormalNC',
    'NvimTreeNormal',
    'NvimTreeNormalNC',
    'DiffviewNormal',
    'MiniMapNormal',
    'NoiceMini',
  }) do
    groups[name] = { link = 'NormalFloat' }
  end
  for _, name in ipairs({
    'FzfLuaBorder',
    'WhichKeyBorder',
    'NoiceCmdlinePopupBorder',
    'DapUIFloatBorder',
    'MiniPickBorder',
    'NoiceConfirmBorder',
    'MiniFilesBorder',
    'NeoTreeFloatBorder',
  }) do
    groups[name] = { link = 'FloatBorder' }
  end
  -- Blink windows use their own groups instead of Pmenu or NormalFloat.
  -- They stay painted when the shared float surface is transparent.
  for _, name in ipairs({ 'BlinkCmpMenu', 'BlinkCmpDoc', 'BlinkCmpSignatureHelp' }) do
    groups[name] = { fg = c.fg, bg = c.deep }
  end
  for _, name in ipairs({ 'BlinkCmpMenuBorder', 'BlinkCmpDocBorder', 'BlinkCmpSignatureHelpBorder' }) do
    groups[name] = { fg = c.edge, bg = c.deep }
  end
  groups.BlinkCmpMenuSelection = { fg = c.fg, bg = c.raised }
  groups.BlinkCmpLabelMatch = { fg = c.accent, bold = true }
  for _, name in ipairs({ 'BlinkCmpKindFunction', 'BlinkCmpKindMethod' }) do
    groups[name] = { fg = c['function'] }
  end
  for _, name in ipairs({ 'BlinkCmpKindVariable', 'BlinkCmpKindText' }) do
    groups[name] = { fg = c.fg }
  end
  for _, name in ipairs({ 'BlinkCmpKindClass', 'BlinkCmpKindInterface', 'BlinkCmpKindModule' }) do
    groups[name] = { fg = c.type }
  end
  for _, name in ipairs({ 'BlinkCmpKindProperty', 'BlinkCmpKindField' }) do
    groups[name] = { fg = c.accent }
  end
  groups.BlinkCmpKindKeyword = { fg = c.keyword }
  groups.BlinkCmpKindConstant = { fg = c.literal }
  groups.BlinkCmpKindSnippet = { fg = c.accent }
  groups.BlinkCmpLabel = { fg = c.fg }
  groups.BlinkCmpLabelDetail = { fg = c.dim }
  groups.BlinkCmpLabelDeprecated = { fg = c.dim, strikethrough = true }
  groups.BlinkCmpScrollBarThumb = { bg = c.border }
  groups.BlinkCmpScrollBarGutter = { bg = c.raised }
  groups.BlinkCmpGhostText = { fg = c.dim }
  groups.BlinkCmpSignatureHelpActiveParameter = { fg = c.accent, bold = true }

  for role, names in pairs({
    ok = {
      'GitSignsAdd',
      'NeoTreeGitAdded',
      'NvimTreeGitNew',
      'MiniDiffSignAdd',
      'DiffviewStatusAdded',
      'DiffviewFilePanelInsertions',
      'NeotestPassed',
      'DapUIWatchesValue',
      'DapUIThread',
      'GrugFarResultsMatchAdded',
      'GrugFarResultsAddIndicator',
      'LazyProgressDone',
    },
    info = {
      'GitSignsChange',
      'NeoTreeGitModified',
      'NvimTreeGitDirty',
      'MiniDiffSignChange',
      'DiffviewStatusModified',
      'DapLogPoint',
      'SnacksNotifierInfo',
      'DapUIBreakpointsInfo',
      'GrugFarResultsChangeIndicator',
      'DapUIModifiedValue',
    },
    error = {
      'GitSignsDelete',
      'NeoTreeGitDeleted',
      'NvimTreeGitDeleted',
      'MiniDiffSignDelete',
      'DiffviewStatusDeleted',
      'DiffviewFilePanelDeletions',
      'NeotestFailed',
      'DapBreakpoint',
      'DapUIWatchesError',
      'GrugFarResultsMatchRemoved',
      'GrugFarResultsRemoveIndicator',
      'SnacksNotifierError',
    },
    warn = { 'NeotestRunning', 'DapStopped', 'DapUIStoppedThread', 'SnacksNotifierWarn' },
    hint = { 'NoiceLspProgressSpinner' },
  }) do
    for _, name in ipairs(names) do
      groups[name] = { fg = c[role] }
    end
  end
  for name, tint in pairs({ GitSignsAddLn = 'add', GitSignsChangeLn = 'modify', GitSignsDeleteLn = 'delete' }) do
    groups[name] = { bg = c[tint] }
  end
  for role, names in pairs({
    accent = {
      'SnacksPickerMatch',
      'SnacksPickerTitle',
      'SnacksDashboardHeader',
      'FzfLuaFzfMatch',
      'FzfLuaTitle',
      'WhichKey',
      'WhichKeyTitle',
      'NoiceCmdlinePopupTitle',
      'NeoTreeRootName',
      'NvimTreeRootFolder',
      'TroubleCount',
      'LazyH2',
      'NeotestFocused',
      'MiniClueNextKey',
      'MiniPickMatchRanges',
      'HLLineNum1',
      'GrugFarResultsHeader',
      'DiffviewFilePanelTitle',
      'RainbowDelimiterOrange',
    },
    type = {
      'WhichKeyGroup',
      'NeoTreeDirectoryName',
      'NeoTreeDirectoryIcon',
      'NvimTreeFolderName',
      'NvimTreeFolderIcon',
      'netrwDir',
      'TroubleFile',
      'MasonHighlight',
      'DapUIScope',
      'DapUIType',
      'NeotestNamespace',
      'NeotestFile',
      'GrugFarResultsPath',
      'RainbowDelimiterCyan',
    },
    dim = {
      'SnacksPickerDir',
      'FzfLuaHeaderText',
      'WhichKeySeparator',
      'WhichKeyValue',
      'NoiceVirtualText',
      'NeoTreeFileName',
      'NvimTreeGitIgnored',
      'TroubleSource',
      'LazyProgressTodo',
      'MasonMuted',
      'NeotestSkipped',
      'MiniClueSeparator',
      'GrugFarHelpHeader',
      'DiffviewFilePanelPath',
      'FlashBackdrop',
    },
    fg = { 'SnacksPickerFile', 'WhichKeyDesc', 'TroubleText', 'DapUIVariable', 'NeotestTest' },
    keyword = { 'RainbowDelimiterRed' },
    ['function'] = { 'RainbowDelimiterYellow' },
    literal = { 'RainbowDelimiterGreen' },
    info = { 'RainbowDelimiterBlue' },
    hint = { 'RainbowDelimiterViolet' },
    gutter = { 'TreesitterContextLineNumber', 'FzfLuaPathLineNr', 'DapUILineNumber', 'GrugFarResultsLineNr' },
    edge = { 'HLChunk1' },
  }) do
    for _, name in ipairs(names) do
      groups[name] = { fg = c[role] }
    end
  end
  for name, background in pairs({
    SnacksPickerCursorLine = 'raised',
    FzfLuaCursorLine = 'raised',
    IlluminatedWordText = 'raised',
    IlluminatedWordRead = 'raised',
    IlluminatedWordWrite = 'raised',
    TreesitterContext = 'line',
    DapStoppedLine = 'line',
    GrugFarResultsMatch = 'raised',
  }) do
    groups[name] = { bg = c[background] }
  end
  for name, role in pairs({
    FlashLabel = 'accent',
    FlashMatch = 'function',
    FlashCurrent = 'accent',
    LazyH1 = 'accent',
    MasonHeader = 'accent',
    MasonHighlightBlock = 'type',
    MiniJump2dSpot = 'accent',
  }) do
    groups[name] = { fg = c.bg, bg = c[role] }
  end
  groups.NoiceVirtualText.italic = config.italic_virtual_text == true
  groups.TreesitterContextBottom = { underline = true, sp = c.border }
  groups.GitSignsCurrentLineBlame = { fg = c.dim, italic = config.italic_virtual_text == true }
  return groups
end

return M

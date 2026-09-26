local M = {}

local roles = {
  fg = {
    'Normal',
    'Identifier',
    'Constant',
    '@variable',
    '@constant',
    '@lsp.type.variable',
    '@lsp.type.event',
    '@lsp.type.constant',
    '@none',
  },
  dim = {
    'Operator',
    'Delimiter',
    '@operator',
    '@punctuation',
    '@punctuation.delimiter',
    '@punctuation.bracket',
    '@punctuation.special',
    '@tag.delimiter',
    '@lsp.type.operator',
  },
  comment = { 'Comment', 'SpecialComment', '@comment', '@comment.documentation', '@lsp.type.comment' },
  keyword = {
    'Statement',
    'Conditional',
    'Repeat',
    'Label',
    'Keyword',
    'Exception',
    'PreProc',
    'Include',
    'Define',
    'PreCondit',
    'StorageClass',
    '@variable.builtin',
    '@keyword',
    '@keyword.function',
    '@keyword.operator',
    '@keyword.import',
    '@keyword.type',
    '@keyword.modifier',
    '@keyword.repeat',
    '@keyword.conditional',
    '@keyword.conditional.ternary',
    '@keyword.exception',
    '@keyword.coroutine',
    '@keyword.directive',
    '@keyword.directive.define',
    '@keyword.return',
    '@label',
    '@tag',
    '@tag.builtin',
    '@lsp.type.keyword',
    '@lsp.type.modifier',
  },
  ['function'] = {
    'Function',
    '@function',
    '@function.builtin',
    '@function.call',
    '@function.method',
    '@function.method.call',
    '@function.macro',
    '@lsp.type.function',
    '@lsp.type.method',
    '@lsp.typemod.function.defaultLibrary',
  },
  literal = {
    'String',
    'Character',
    'Number',
    'Boolean',
    'Float',
    '@constant.builtin',
    '@number',
    '@number.float',
    '@boolean',
    '@string',
    '@string.documentation',
    '@string.regexp',
    '@string.escape',
    '@string.special',
    '@string.special.url',
    '@string.special.path',
    '@character',
    '@character.special',
    '@lsp.type.string',
    '@lsp.type.number',
    '@lsp.type.boolean',
    '@lsp.type.enumMember',
    '@lsp.type.regexp',
  },
  accent = {
    'Special',
    'SpecialChar',
    'Macro',
    '@variable.parameter',
    '@variable.parameter.builtin',
    '@variable.member',
    '@property',
    '@field',
    '@attribute',
    '@attribute.builtin',
    '@tag.attribute',
    '@lsp.type.parameter',
    '@lsp.type.property',
    '@lsp.type.decorator',
    '@lsp.type.macro',
  },
  type = {
    'Type',
    'Structure',
    'Typedef',
    '@type',
    '@type.builtin',
    '@type.definition',
    '@constructor',
    '@module',
    '@module.builtin',
    '@lsp.type.class',
    '@lsp.type.enum',
    '@lsp.type.interface',
    '@lsp.type.namespace',
    '@lsp.type.struct',
    '@lsp.type.type',
    '@lsp.type.typeParameter',
  },
}

local severities = { Error = 'error', Warn = 'warn', Info = 'info', Hint = 'hint', Ok = 'ok' }

function M.get(c, config)
  config = config or {}
  local groups = {}
  for role, names in pairs(roles) do
    for _, name in ipairs(names) do
      groups[name] = { fg = c[role] }
    end
  end
  groups.Normal.bg = c.bg
  for _, name in ipairs(roles.comment) do
    groups[name].italic = config.italic_comments ~= false
  end

  groups.NormalNC = { fg = c.fg, bg = c.bg }
  groups.NormalFloat = { fg = c.fg, bg = c.deep }
  groups.FloatBorder = { fg = c.edge, bg = c.deep }
  groups.FloatTitle = { fg = c.accent, bold = true }
  groups.FloatFooter = { fg = c.dim, bg = c.deep }

  groups.CursorLine = { bg = c.line }
  groups.CursorColumn = { bg = c.line }
  groups.ColorColumn = { bg = c.line }
  groups.LineNr = { fg = c.gutter }
  groups.LineNrAbove = { fg = c.gutter }
  groups.LineNrBelow = { fg = c.gutter }
  groups.CursorLineNr = { fg = c.accent, bold = true }
  groups.SignColumn = { fg = c.gutter }
  groups.FoldColumn = { fg = c.gutter }
  groups.Folded = { fg = c.dim, bg = c.line }

  groups.Pmenu = { fg = c.fg, bg = c.deep }
  groups.PmenuKind = { fg = c.type, bg = c.deep }
  groups.PmenuExtra = { fg = c.dim, bg = c.deep }
  groups.PmenuSel = { fg = c.fg, bg = c.raised }
  groups.PmenuKindSel = { fg = c.fg, bg = c.raised }
  groups.PmenuExtraSel = { fg = c.fg, bg = c.raised }
  groups.PmenuMatch = { fg = c.accent, bold = true }
  groups.PmenuMatchSel = { fg = c.accent, bold = true }
  groups.PmenuBorder = { fg = c.edge, bg = c.deep }
  groups.PmenuSbar = { bg = c.raised }
  groups.PmenuThumb = { bg = c.border }
  groups.PreInsert = { fg = c.dim, italic = config.italic_virtual_text == true }
  groups.WildMenu = { fg = c.bg, bg = c.accent }

  groups.StatusLine = { fg = c.fg, bg = c.raised }
  groups.StatusLineNC = { fg = c.dim, bg = c.line }
  groups.TabLine = { fg = c.dim, bg = c.line }
  groups.TabLineFill = { bg = c.line }
  groups.TabLineSel = { fg = c.fg, bg = c.bg, bold = true }
  groups.WinBar = { fg = c.dim, bg = c.bg }
  groups.WinBarNC = { fg = c.dim, bg = c.bg }
  groups.WinSeparator = { fg = c.border, bg = c.bg }
  groups.VertSplit = { fg = c.border, bg = c.bg }
  groups.MsgArea = { fg = c.dim, bg = c.bg }
  groups.MsgSeparator = { fg = c.border }
  groups.NonText = { fg = c.edge }
  groups.Whitespace = { fg = c.border }
  groups.SpecialKey = { fg = c.edge }
  groups.EndOfBuffer = { fg = c.line, bg = c.bg }
  groups.Conceal = { fg = c.dim }
  groups.Directory = { fg = c.type }
  groups.Title = { fg = c.accent, bold = true }
  groups.QuickFixLine = { fg = c.fg, bg = c.raised }
  groups.qfLineNr = { fg = c.gutter }
  groups.qfFileName = { fg = c.type }

  groups.Visual = { fg = c.fg, bg = c.selection }
  groups.VisualNOS = { fg = c.fg, bg = c.selection }
  groups.Search = { fg = c.bg, bg = c['function'] }
  groups.IncSearch = { fg = c.bg, bg = c.accent }
  groups.CurSearch = { fg = c.bg, bg = c.accent }

  for name, role in pairs({
    ErrorMsg = 'error',
    WarningMsg = 'warn',
    OkMsg = 'ok',
    MoreMsg = 'info',
    Question = 'info',
  }) do
    groups[name] = { fg = c[role] }
  end

  for severity, role in pairs(severities) do
    for _, prefix in ipairs({ 'Diagnostic', 'DiagnosticSign' }) do
      groups[prefix .. severity] = { fg = c[role] }
    end
    groups['DiagnosticVirtualText' .. severity] = {
      fg = c[role],
      bg = c[role .. '_tint'],
      italic = config.italic_virtual_text == true,
    }
    groups['DiagnosticLineNr' .. severity] = { fg = c[role], bg = c[role .. '_tint'] }
    groups['DiagnosticUnderline' .. severity] = { undercurl = true, sp = c[role] }
  end

  for name, role in pairs({
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
    groups[name] = { fg = c[role] }
  end
  groups.DiffAdd = { fg = c.fg, bg = c.add }
  groups.DiffDelete = { fg = c.fg, bg = c.delete }
  groups.DiffChange = { fg = c.fg, bg = c.modify }
  groups.DiffText = { fg = c.fg, bg = c.modify }

  groups.Error = { fg = c.error }
  groups.Todo = { fg = c.warn }
  groups['@error'] = { fg = c.error }
  for name, role in pairs({
    ['@comment.error'] = 'error',
    ['@comment.warning'] = 'warn',
    ['@comment.todo'] = 'info',
    ['@comment.note'] = 'hint',
  }) do
    groups[name] = { fg = c[role] }
  end
  groups['@markup.list.checked'] = { fg = c.ok }
  groups.LspInlayHint = { fg = c.hint, bg = c.hint_tint, italic = config.italic_virtual_text == true }
  groups.Italic = { italic = true }
  groups['@markup.italic'] = { italic = true }
  groups.Bold = { bold = true }
  groups['@markup.strong'] = { bold = true }

  if config.dim_inactive then groups.NormalNC.bg = c.deep end
  if config.transparent then
    for _, name in ipairs({
      'Normal',
      'NormalNC',
      'NormalFloat',
      'FloatBorder',
      'SignColumn',
      'FoldColumn',
      'StatusLine',
      'StatusLineNC',
      'TabLine',
      'TabLineFill',
      'TabLineSel',
      'WinSeparator',
      'VertSplit',
      'EndOfBuffer',
      'MsgArea',
      'WinBar',
      'WinBarNC',
    }) do
      groups[name].bg = nil
    end
  end

  return vim.tbl_extend('force', groups, require('grisaille.plugins').get(c, config))
end

return M

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

function M.get(c)
  local groups = {}
  for role, names in pairs(roles) do
    for _, name in ipairs(names) do
      groups[name] = { fg = c[role] }
    end
  end
  groups.Normal.bg = c.bg

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
    groups['DiagnosticVirtualText' .. severity] = { fg = c[role], bg = c[role .. '_tint'] }
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

  return groups
end

return M

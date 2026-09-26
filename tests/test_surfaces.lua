local expect = MiniTest.expect
local child = require('tests.helpers').new_clean_neovim()

before_each(function() child.setup() end)
teardown(function() child.stop() end)

local function hex(color) return tonumber(color:sub(2), 16) end

local function applied(depth)
  child.cmd('colorscheme grisaille' .. (depth == 'hard' and '' or '-' .. depth))
  return child.lua_get(string.format("require('grisaille.palette').resolve('balanced', '%s')", depth)),
    child.lua_get('vim.api.nvim_get_hl(0, {})')
end

describe('editor surfaces through public colorschemes', function()
  it('paints readable windows, gutters, floats, menus, and chrome at each depth by default', function()
    for _, depth in ipairs({ 'hard', 'medium', 'soft' }) do
      local c, h = applied(depth)
      for _, group in ipairs({ 'Normal', 'NormalNC' }) do
        expect.equality(h[group].bg, hex(c.bg), depth .. ': ' .. group)
      end
      for _, group in ipairs({ 'SignColumn', 'FoldColumn' }) do
        expect.equality(h[group].bg, nil, depth .. ': ' .. group .. ' inherits the window ground')
        expect.equality(h[group].fg, hex(c.gutter))
      end
      expect.equality(h.NormalNC.fg, hex(c.fg))
      expect.equality(h.CursorLine.bg, hex(c.line))
      expect.equality(h.LineNr.fg, hex(c.gutter))
      expect.equality(h.NormalFloat.bg, hex(c.deep))
      expect.equality(h.NormalFloat.fg, hex(c.fg))
      expect.equality(h.FloatBorder.bg, hex(c.deep))
      expect.equality(h.FloatBorder.fg, hex(c.edge))
      expect.equality(h.Pmenu.bg, hex(c.deep))
      expect.equality(h.Pmenu.fg, hex(c.fg))
      expect.equality(h.PmenuSel.bg, hex(c.raised))
      expect.equality(h.PmenuSel.fg, hex(c.fg))
      expect.equality(h.SnacksNormal.link, 'NormalFloat')
      expect.equality(h.BlinkCmpMenu.bg, hex(c.deep))
      expect.equality(h.StatusLine.bg, hex(c.raised))
      expect.equality(h.StatusLineNC.bg, hex(c.line))
      expect.equality(h.WinSeparator.fg, hex(c.border))
    end
  end)

  it('dims inactive windows to the deep ground only when requested', function()
    local c, h = applied('medium')
    expect.equality(h.NormalNC.bg, hex(c.bg))
    child.lua([[require('grisaille').setup({ dim_inactive = true })]])
    c, h = applied('medium')
    expect.equality(h.Normal.bg, hex(c.bg))
    expect.equality(h.NormalNC.bg, hex(c.deep))
    expect.equality(h.SignColumn.bg, nil)
    expect.equality(h.FoldColumn.bg, nil)
    child.lua([[require('grisaille').setup({ transparent = true })]])
    c, h = applied('medium')
    expect.equality(h.NormalNC.bg, nil)
    expect.equality(h.Pmenu.bg, hex(c.deep))
  end)

  it('clears shared editor and float surfaces but keeps completion menus painted', function()
    child.lua([[require('grisaille').setup({ transparent = true })]])
    for _, depth in ipairs({ 'hard', 'medium', 'soft' }) do
      local c, h = applied(depth)
      for _, group in ipairs({
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
        expect.equality(h[group].bg, nil, depth .. ': ' .. group)
      end
      expect.equality(h.FloatBorder.fg, hex(c.edge))
      expect.equality(h.NormalFloat.fg, hex(c.fg))
      expect.equality(h.Pmenu.bg, hex(c.deep))
      expect.equality(h.PmenuSel.bg, hex(c.raised))
      expect.equality(h.PmenuBorder.bg, hex(c.deep))
      expect.equality(h.BlinkCmpMenu.bg, hex(c.deep))
      expect.equality(h.BlinkCmpDoc.bg, hex(c.deep))
      expect.equality(h.BlinkCmpSignatureHelp.bg, hex(c.deep))
      expect.equality(h.BlinkCmpMenuSelection.bg, hex(c.raised))
      expect.equality(h.SnacksNormal.bg, nil)
      expect.equality(h.SnacksNormal.link, 'NormalFloat')
    end
  end)

  it('sets comment and virtual-text italics independently while retaining markup emphasis', function()
    local comment = { 'Comment', 'SpecialComment', '@comment', '@comment.documentation', '@lsp.type.comment' }
    local virtual = {
      'LspInlayHint',
      'DiagnosticVirtualTextError',
      'DiagnosticVirtualTextWarn',
      'DiagnosticVirtualTextInfo',
      'DiagnosticVirtualTextHint',
      'DiagnosticVirtualTextOk',
      'PreInsert',
    }
    for _, case in ipairs({
      { options = nil, comments = true, virtual = nil },
      { options = { italic_comments = false, italic_virtual_text = true }, comments = nil, virtual = true },
      { options = { italic_comments = true, italic_virtual_text = false }, comments = true, virtual = nil },
      { options = { italic_comments = false, italic_virtual_text = false }, comments = nil, virtual = nil },
    }) do
      if case.options then child.lua('require("grisaille").setup(' .. vim.inspect(case.options) .. ')') end
      local _, h = applied('soft')
      for _, group in ipairs(comment) do
        expect.equality(h[group].italic, case.comments)
      end
      for _, group in ipairs(virtual) do
        expect.equality(h[group].italic, case.virtual)
      end
      expect.equality(h.Italic.italic, true)
      expect.equality(h['@markup.italic'].italic, true)
      expect.equality(h.Bold.bold, true)
      expect.equality(h['@markup.strong'].bold, true)
    end
  end)
end)

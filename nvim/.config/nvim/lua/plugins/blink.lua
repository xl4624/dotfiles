return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'fang2hou/blink-copilot',
    {
      'L3MON4D3/LuaSnip',
      build = "make install_jsregexp",
      version = 'v2.*',
      dependencies = { 'rafamadriz/friendly-snippets' },
    },
  },

  -- Use a release tag to download pre-built binaries
  version = '*',

  opts = {
    keymap = { preset = 'default' },
    appearance = {
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },
    snippets = { preset = 'luasnip' },

    completion = {
      menu = {
        draw = {
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                if ctx.kind == 'Snippet' then
                  return '󱄽'
                elseif ctx.source_name == 'copilot' then
                  return ''
                end
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
          },
        },
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'snippets', 'lsp', 'path', 'buffer', 'copilot' },
      providers = {
        copilot = {
          name = 'copilot',
          module = 'blink-copilot',
          async = true,
        },
      },
    },

    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}

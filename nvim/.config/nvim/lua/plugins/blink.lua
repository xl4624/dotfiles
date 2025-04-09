return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'zbirenbaum/copilot.lua',
    'giuxtaposition/blink-cmp-copilot',
    {
      'L3MON4D3/LuaSnip',
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
      default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
      providers = {
        snippets = {
          score_offset = 5,
        },
        lsp = {
          score_offset = 4,
        },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 3,
          async = true,
        },
        path = {
          score_offset = 2,
        },
        buffer = {
          min_keyword_length = 5,
          score_offset = 1,
        },
      },
    },

    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}

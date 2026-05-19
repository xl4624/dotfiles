return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- DAP UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Mason integration for installing adapters
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific adapters
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = '[D]ebug: [C]ontinue / Start',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = '[D]ebug: Toggle [B]reakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[D]ebug: Conditional [B]reakpoint',
    },
    {
      '<leader>dC',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = '[D]ebug: [C]lear all breakpoints',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = '[D]ebug: Run [L]ast',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = '[D]ebug: [T]erminate',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = '[D]ebug: Toggle [R]EPL',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = '[D]ebug: Toggle [U]I',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = '[D]ebug: [E]val expression',
    },
    {
      '<leader>dh',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = '[D]ebug: [H]over value',
    },
    -- IDE-standard muscle memory (matches VS Code / JetBrains / Visual Studio)
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<S-F11>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve', -- Go
        'python', -- debugpy
        'codelldb', -- C / C++ / Rust
      },
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dap_session'] = dapui.open
    dap.listeners.before.event_terminated['dap_session'] = dapui.close
    dap.listeners.before.event_exited['dap_session'] = dapui.close

    -- Go: nvim-dap-go
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Python: dap-python
    local debugpy = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
    if vim.fn.executable(debugpy) == 1 then
      require('dap-python').setup(debugpy)
    end

    -- C / C++ / Rust: codelldb
    local function prompt_executable()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end
    for _, lang in ipairs { 'c', 'cpp', 'rust' } do
      dap.configurations[lang] = {
        {
          name = 'Launch executable (codelldb)',
          type = 'codelldb',
          request = 'launch',
          program = prompt_executable,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
    end
  end,
}

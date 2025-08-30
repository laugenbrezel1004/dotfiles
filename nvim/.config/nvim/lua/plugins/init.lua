return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

 {
  'mrcjkb/rustaceanvim',
  version = '^5',
  ft = { 'rust' },
  -- Lazy loading is handled by `ft`
  -- This config will be executed when the plugin is loaded

  config = function()
    -- Get the current buffer's filetype to conditionally setup keymaps
    local current_buftype = vim.api.nvim_buf_get_option(0, 'filetype')

    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        -- These apply to all Rust buffers
      },

      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- This function will be called once the LSP is attached to a buffer
          -- You can add custom keymaps or other LSP-related setup here

          -- Set keymaps specific to Rust (with lsp-zero/nvim-lspconfig, you might do this elsewhere)
          local opts = { buffer = bufnr, remap = false }
          -- Example: Rename symbol
          vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, opts)
          -- Example: Code actions
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

          -- You can use which-key to describe your keymaps
          -- require('which-key').register({
          --   ['<leader>r'] = { name = '[R]ust', _ = 'which_key_ignore' },
          -- }, { buffer = bufnr })
        end,

        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            check = {
              command = "clippy", -- Use clippy for `:RustLsp check actions`
            },
            cargo = {
                allFeatures = true,
              },
            -- Other settings can be added here
            -- See: https://rust-analyzer.github.io/manual.html#configuration
          },
        },
      },

      -- DAP configuration
      dap = {
        -- You can customize the adapter here
        -- adapter = {
        --   type = 'executable',
        --   command = 'lldb-vscode',
        --   name = 'rt_lldb',
        -- },
      },
    }

    -- Only set the keymaps if the current buffer is a Rust file
    -- This avoids errors when opening Neovim without a file or with a non-Rust file
    if current_buftype == 'rust' then
      -- Set keymaps for the current buffer
      -- These are useful Rust-specific commands provided by rustaceanvim
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = 0, desc = desc })
      end

      -- Code actions
      map('n', '<leader>ra', '<cmd>RustCodeAction<cr>', '[R]ust Code [A]ction')
      map('n', '<leader>rr', '<cmd>RustLsp runnables<cr>', '[R]ust [R]unnables (tests/benches)')
      map('n', '<leader>rp', '<cmd>RustLsp parentModule<cr>', '[R]ust [P]arent Module')
      map('n', '<leader>rj', '<cmd>RustLsp joinLines<cr>', '[R]ust [J]oin Lines')
      map('n', '<leader>rh', '<cmd>RustLsp hover actions<cr>', '[R]ust [H]over Actions')
      map('n', '<leader>rH', '<cmd>RustLsp hover range<cr>', '[R]ust [H]over Range')

      -- Debugging (requires nvim-dap)
      map('n', '<leader>rd', '<cmd>RustLsp debuggables<cr>', '[R]ust [D]ebuggables')
    end
  end,
},

  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true
          },
        },
      }
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
    end
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },
}

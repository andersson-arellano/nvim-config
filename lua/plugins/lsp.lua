return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "mason-org/mason.nvim",
        opts = {}
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local lspConf = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities();
      lspConf.lua_ls.setup({ capabilities = capabilities })
      -- local mason_register = require("mason_register")
      -- local vue_lenguage_server = mason_register.get_package("vue-lenguage-server"): get_install_path()
      --   .. "/node_modules/@vue/language-server"
      --   lspConf.ts_ls.setup({
      --     capabilities = capabilities,
      --     init_options = {
      --       plugins = {
      --         {
      --         name = "@vue/typescript-plugin",
      --         location = vue_language_server,
      --         languages = { "vue" },              }
      --       }
      --     },
      --     filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
      --   })
 
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end
          local telescopeBuiltIn = require("telescope.builtin")

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          nmap('gd', telescopeBuiltIn.lsp_definitions, '[G]oto [D]efinition')
          nmap('gr', telescopeBuiltIn.lsp_references, '[G]oto [R]eferences')
          nmap('gI', telescopeBuiltIn.lsp_implementations, '[G]oto [I]mplementation')
          nmap('<leader>D', telescopeBuiltIn.lsp_type_definitions, 'Type [D]efinition')
          nmap('<leader>ds', telescopeBuiltIn.lsp_document_symbols, '[D]ocument [S]ymbols')
          nmap('<leader>ws', telescopeBuiltIn.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- See `:help K` for why this keymap
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')
          -- nmap('<leader>i', vim.lsp.buf.completion, '[i]Suggest')
          -- nmap('<leader>i', vim.lsp.completion, '[i]Suggest')
          -- vim.keymap.set('i', '<C-k>', vim.lsp.buf.completion)

          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })

          vim.keymap.set('n', '<C-f>', ':Format<CR>')
        end
      })
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- local vue_language_server_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      --
      -- local vue_plugin = {
      --   name = "@vue/typescript-plugin",
      --   location = vue_language_server_path,
      --   languages = { "vue" },
      --   configNamespace = "typescript",
      -- }
      --
      -- local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

      local servers = {
        gopls = {},
        ts_ls = {
        --   init_options = {
        --     plugins = {
        --       vue_plugin,
        --     },
        --   },
        --   filetypes = tsserver_filetypes,
        }
        ,

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        --
        -- vue_ls = {}

        -- dartls = {
        --   cmd = { "dart", "language-server", "--protocol=lsp" },
        --   filetypes = { "dart" },
        --   init_options = {
        --     closingLabels = true,
        --     flutterOutline = true,
        --     onlyAnalyzeProjectsWithOpenFiles = true,
        --     outline = true,
        --     suggestFromUnimportedLibraries = true,
        --   },
        --   -- root_dir = root_pattern("pubspec.yaml"),
        --   settings = {
        --     dart = {
        --       completeFunctionCalls = true,
        --       showTodos = true,
        --     },
        --   },
        -- on_attach = function(client, bufnr)	
        -- end,
        -- }
        
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspConf[server_name].setup(server)
          end,
        },
      }

    local vue_language_server_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

    local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
    }
    local ts_ls_config = {
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
      filetypes = tsserver_filetypes,
    }
    local vue_ls_config = {}

    -- nvim 0.11 or above
    vim.lsp.config('vue_ls', vue_ls_config)
    vim.lsp.config('ts_ls', ts_ls_config)
    vim.lsp.enable({'ts_ls', 'vue_ls'})
    end
  },
}

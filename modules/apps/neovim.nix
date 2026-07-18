{
  config.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      programs.nvf = {
        enable = true;
        settings = {
          vim = {
            viAlias = false;
            vimAlias = true;

            # vim.opts and vim.options are aliased
            options = {
              shiftwidth = 2;
              tabstop = 2;
              expandtab = true;
              autoindent = true;
              updatetime = 200;

              # Smart word wrap
              wrap = true;
              linebreak = true;
              breakindent = true;

              # Autosave
              autowrite = true;
              autowriteall = true;

              # Quality of life
              cursorline = true;
              scrolloff = 8;
              sidescrolloff = 8;
              ignorecase = true;
              smartcase = true;
              signcolumn = "yes";
            };

            spellcheck = {
              enable = true;
            };

            clipboard = {
              enable = true;
              registers = "unnamedplus";
              providers.wl-copy.enable = true;
            };

            lsp = {
              # This must be enabled for the language modules to hook into
              # the LSP API.
              enable = true;

              formatOnSave = true;
              lightbulb.enable = true;
              trouble.enable = true;
              lspSignature.enable = true; # conflicts with blink-cmp, safe with nvim-cmp
              presets.tailwindcss-language-server.enable = true;
            };

            debugger = {
              nvim-dap = {
                enable = true;
                ui.enable = true;
              };
            };

            # This section does not include a comprehensive list of available language modules.
            # To list all available language module options, please visit the nvf manual.
            languages = {
              enableFormat = true;
              enableTreesitter = true;
              enableExtraDiagnostics = true;

              # Languages that will be supported in default and maximal configurations.
              nix.enable = true;
              markdown.enable = true;

              # Languages that are enabled in the maximal configuration.
              bash.enable = true;
              clang.enable = true;
              css.enable = true;
              html.enable = true;
              json.enable = true;
              lua.enable = true;
              python.enable = true;
              typescript.enable = true;
              tex.enable = true;

              # Language modules that are not as common.
              scala.enable = true;
              r.enable = true;
            };

            visuals = {
              nvim-web-devicons.enable = true;
              nvim-cursorline.enable = true;
              cinnamon-nvim.enable = true;
              fidget-nvim.enable = true;

              highlight-undo.enable = true;
              indent-blankline = {
                enable = true;
                setupOpts.exclude.filetypes = [
                  "dashboard"
                  "alpha"
                  "neo-tree"
                ];
              };
            };

            statusline = {
              lualine = {
                enable = true;
                theme = "everforest";
                setupOpts = {
                  sections = {
                    lualine_z = { };
                  };
                };
              };
            };

            theme = {
              enable = true;
              name = "everforest";
              style = "medium";
            };

            autopairs.nvim-autopairs.enable = true;

            # nvf provides various autocomplete options. The tried and tested nvim-cmp
            # is enabled in default package, because it does not trigger a build. We
            # enable blink-cmp in maximal because it needs to build its rust fuzzy
            # matcher library.
            autocomplete = {
              nvim-cmp.enable = true;
            };

            snippets.luasnip.enable = true;

            filetree = {
              neo-tree = {
                enable = true;
              };
            };

            tabline = {
              nvimBufferline.enable = true;
            };

            treesitter.context.enable = true;

            binds = {
              whichKey.enable = true;
              cheatsheet.enable = true;
            };

            telescope.enable = true;

            git = {
              enable = true;
              gitsigns.enable = true;
              gitsigns.codeActions.enable = false; # throws an annoying debug message
            };

            dashboard = {
              dashboard-nvim.enable = true;
            };

            notify = {
              nvim-notify.enable = true;
            };

            utility = {
              diffview-nvim.enable = true;
              surround.enable = true;
              smart-splits.enable = true;
              undotree.enable = true;

              motion = {
                flash-nvim.enable = true;
              };
            };

            notes = {
              todo-comments.enable = true;
            };

            terminal = {
              toggleterm = {
                enable = true;
                lazygit.enable = true;
                setupOpts.shade_terminals = false;
              };
            };

            ui = {
              borders.enable = true;
              noice.enable = true;
              colorizer.enable = true;
              illuminate.enable = true;
              smartcolumn = {
                enable = true;
                setupOpts.custom_colorcolumn = {
                  # this is a freeform module, it's `buftype = int;` for configuring column position
                  nix = "110";
                  python = "90";
                  c = "80";
                  cpp = "80";
                  tex = "80";
                };
              };
              fastaction.enable = true;
            };

            assistant = {
              copilot = {
                enable = true;
                cmp.enable = true;
              };
            };

            session = {
              nvim-session-manager = {
                enable = true;
                setupOpts.autoload_mode = "CurrentDir"; # Restored: loads automatically only when launched without arguments
              };
            };

            comments = {
              comment-nvim.enable = true;
            };

            keymaps = [
              {
                key = "<leader>e";
                mode = [ "n" ];
                action = "<cmd>Neotree toggle<CR>";
                silent = true;
                desc = "Toggle Neo-tree";
              }
              {
                key = "<leader>bd";
                mode = [ "n" ];
                action = "<cmd>bdelete<CR>";
                silent = true;
                desc = "Delete Buffer";
              }
              {
                key = "<S-h>";
                mode = [ "n" ];
                action = "<cmd>bprevious<CR>";
                silent = true;
                desc = "Previous Buffer";
              }
              {
                key = "<S-l>";
                mode = [ "n" ];
                action = "<cmd>bnext<CR>";
                silent = true;
                desc = "Next Buffer";
              }
              {
                key = "<leader>w";
                mode = [ "n" ];
                action = "<cmd>w<CR>";
                silent = true;
                desc = "Save File";
              }
              {
                key = "<leader>q";
                mode = [ "n" ];
                action = "<cmd>qa<CR>";
                silent = true;
                desc = "Quit All";
              }
              {
                key = "<Esc>";
                mode = [ "n" "i" ];
                action = "<cmd>nohlsearch<CR><Esc>";
                silent = true;
                desc = "Clear Search Highlights";
              }
              {
                key = "<leader>|";
                mode = [ "n" ];
                action = "<cmd>vsplit<CR>";
                silent = true;
                desc = "Split Window Vertically";
              }
              {
                key = "<leader>-";
                mode = [ "n" ];
                action = "<cmd>split<CR>";
                silent = true;
                desc = "Split Window Horizontally";
              }
              {
                key = "<";
                mode = [ "v" ];
                action = "<gv";
                silent = true;
                desc = "Indent Left (Keep Selection)";
              }
              {
                key = ">";
                mode = [ "v" ];
                action = ">gv";
                silent = true;
                desc = "Indent Right (Keep Selection)";
              }
            ];

            autocmds = [
              {
                event = [
                  "FocusLost"
                  "BufLeave"
                  "InsertLeave"
                  "CursorHold"
                ];
                pattern = [ "*" ];
                command = "silent! wa";
              }
            ];

            extraPlugins = with pkgs.vimPlugins; {
              "vimtex" = {
                package = vimtex;
                setup = ''
                  vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
                  vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
                  vim.g.vimtex_quickfix_open_on_warning = 0
                '';
              };
              "auto-dark-mode.nvim" = {
                package = auto-dark-mode-nvim;
                setup = ''
                  require('auto-dark-mode').setup({
                    update_interval = 1000,
                    set_dark_mode = function()
                      vim.api.nvim_set_option_value("background", "dark", {})
                      vim.cmd("colorscheme everforest")
                    end,
                    set_light_mode = function()
                      vim.api.nvim_set_option_value("background", "light", {})
                      vim.cmd("colorscheme everforest")
                    end,
                  })
                '';
              };
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        gcc
        gnumake
        lazygit
        neovim-remote
        wl-clipboard
      ];
    };
}

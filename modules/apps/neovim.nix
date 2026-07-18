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

              # LazyVim-like quality of life features
              cursorline = true;
              scrolloff = 8;
              sidescrolloff = 8;
              ignorecase = true;
              smartcase = true;
              signcolumn = "yes";
            };

            viAlias = false;
            vimAlias = true;

            spellcheck = {
              enable = true;
              languages = ["en"];
              programmingWordlist.enable = true;
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
              presets.tailwindcss-language-server.enable = true;
              trouble.enable = true;
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
              clang.enable = true;
              python.enable = true;
              tex.enable = true;
              scala.enable = true;
              r.enable = true;
            };

            visuals = {
              indent-blankline = {
                enable = true;
                setupOpts.exclude.filetypes = [
                  "dashboard"
                  "alpha"
                  "neo-tree"
                ];
              };
              fidget-nvim.enable = true;
            };

            notify = {
              nvim-notify.enable = true;
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

            filetree = {
              neo-tree = {
                enable = true;
              };
            };

            tabline = {
              nvimBufferline.enable = true;
            };

            binds = {
              whichKey.enable = true;
            };

            telescope.enable = true;

            git = {
              enable = true;
              gitsigns.enable = true;
            };

            dashboard = {
              dashboard-nvim.enable = true;
            };

            utility = {
              surround.enable = true;
              smart-splits.enable = true;
              motion.flash-nvim.enable = true;
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
              noice.enable = true;
              colorizer.enable = true;
              illuminate.enable = true;
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
                setupOpts.autoload_mode = "CurrentDir";
              };
            };

            keymaps = [
              {
                key = "<leader>e";
                mode = [ "n" ];
                action = "<cmd>Neotree toggle<CR>";
                silent = true;
                desc = "Toggle Neo-tree";
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
              "vim-dirtytalk-spell" = {
                package = pkgs.stdenv.mkDerivation {
                  name = "vim-dirtytalk-spell";
                  src = pkgs.fetchFromGitHub {
                    owner = "psliwka";
                    repo = "vim-dirtytalk";
                    rev = "aa57ba902b04341a04ff97214360f56856493583";
                    sha256 = "sha256-azU5jkv/fD/qDDyCU1bPNXOH6rmbDauG9jDNrtIXc0Y=";
                  };
                  nativeBuildInputs = [ pkgs.neovim ];
                  buildPhase = ''
                    mkdir -p spell
                    cat wordlists/*.words > spell/programming.utf-8.add
                    export LC_ALL=C.utf8
                    nvim --headless -n -c "mkspell! spell/programming.utf-8.spl spell/programming.utf-8.add" -c "q"
                  '';
                  installPhase = ''
                    mkdir -p $out/spell
                    cp spell/programming.utf-8.spl $out/spell/
                  '';
                };
              };
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        gcc
        gnumake
        lazygit
        #lua-language-server
        neovim-remote
        #nixd
        tree-sitter
        wl-clipboard
      ];
    };
}

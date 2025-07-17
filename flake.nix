{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    ...
  } @ inputs: {
    packages.x86_64-linux = {
      default =
        (nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ({
              pkgs,
              lib,
              ...
            }: {
              config.vim = {
                options = {
                  autoindent = true;
                  mouse = "";
                  shiftwidth = 2;
                  signcolumn = "yes";
                  tabstop = 2;
                  termguicolors = true;
                };

                theme = {
                  enable = true;
                  name = "rose-pine";
                  style = "main";
                };

                mini.icons.enable = true;
                visuals.nvim-web-devicons.enable = true;

                keymaps = [
                  {
                    key = "<leader>ff";
                    mode = ["n"];
                    action = ":lua Snacks.picker.files()<CR>";
                    desc = "Toggle File Picker";
                  }
                  {
                    key = "<leader>fb";
                    mode = ["n"];
                    action = ":lua Snacks.picker.buffers()<CR>";
                    desc = "Toggle Buffers Picker";
                  }
                  {
                    key = "<leader>fg";
                    mode = ["n"];
                    action = ":lua Snacks.picker.grep()<CR>";
                    desc = "Toggle Grep Picker";
                  }
                ];

                treesitter.enable = true;

                diagnostics = {
                  enable = true;
                  config = {
                    signs.text = lib.generators.mkLuaInline ''
                      {
                        [vim.diagnostic.severity.ERROR] = " ";
                        [vim.diagnostic.severity.WARN] = " ";
                        [vim.diagnostic.severity.HINT] = "󰠠 ";
                        [vim.diagnostic.severity.INFO] = " ";
                      }
                    '';
                    virtual_lines = true;
                    virtual_text = true;
                  };
                };

                lsp = {
                  enable = true;
                  formatOnSave = true;
                };

                languages = {
                  enableTreesitter = true;
                  nix = {
                    enable = true;
                    format.enable = true;
                    lsp.enable = true;
                  };
                  tailwind = {
                    enable = true;
                    lsp.enable = true;
                  };
                };

                formatter.conform-nvim = {
                  enable = true;
                };

                utility.snacks-nvim = {
                  enable = true;
                  setupOpts = {
                    picker.enabled = true;
                  };
                };

                extraPackages = with nixpkgs.legacyPackages.x86_64-linux; [
                  ripgrep
                ];
              };
            })
            ({pkgs, ...}: {
              config.vim.extraPlugins = {
                persistence = {
                  package = pkgs.vimPlugins.persistence-nvim;
                  setup = ''
                    require("persistence").setup()

                    vim.api.nvim_create_autocmd("VimEnter", {
                      callback = function()
                        if vim.fn.argc() == 0 then
                          require("persistence").load()
                        end
                      end,
                    })
                  '';
                };
              };
            })
          ];
        }).neovim;
    };
  };
}

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
            {
              config.vim = {
                options = {
                  autoindent = true;
                  mouse = "";
                  shiftwidth = 2;
                  signcolumn = "yes";
                  tabstop = 2;
                  termguicolors = true;
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
            }
            ({pkgs, ...}: let
              monokai-pro = pkgs.vimUtils.buildVimPlugin {
                pname = "monokai-pro.nvim";
                version = "2024-07-08";
                src = pkgs.fetchFromGitHub {
                  owner = "loctvl842";
                  repo = "monokai-pro.nvim";
                  rev = "31bad737610ec211de086d373c73025f39de93cb";
                  sha256 = "sha256-zYY2MZXAvKqdahu1UR8MV0QiW2g4blbiXQtk1OrsQsQ=";
                };
              };
            in {
              config.vim.extraPlugins = {
                monokai-pro = {
                  package = monokai-pro;
                  setup = ''
                    require("monokai-pro").setup({
                      filter = "octagon",
                      transparent_background = false,
                      terminal_colors = true,
                      devicons = true
                    })
                    vim.cmd.colorscheme("monokai-pro")
                  '';
                };
              };
            })
          ];
        }).neovim;
    };
  };
}

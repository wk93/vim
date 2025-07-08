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

                theme = {
                  enable = true;
                  name = "dracula";
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
          ];
        }).neovim;
    };
  };
}

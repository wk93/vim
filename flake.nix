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
                theme = {
                  enable = true;
                  name = "dracula";
                };

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
              };
            }
          ];
        }).neovim;
    };
  };
}

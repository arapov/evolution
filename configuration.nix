{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.anton = { pkgs, ... }: {
    home.stateVersion = "22.05";

    home.packages = with pkgs; [
      git-crypt tig
      mc
    ];

    programs.git = {
      enable = true;
      userName = "Anton Arapov";
      userEmail = "anton@deadbeef.mx";
      signing = {
        key = "134C02E813889057DA2F3FDBEDDD4C5DAA149BBE";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "master";
        core = {
          editor = "vim";
          whitespace = "trailing-space,space-before-tab";
        };
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
        url = { # makes rust's cargo happy again
          "https://github.com/rust-lang/crates.io-index" = {
            insteadOf = "https://github.com/rust-lang/crates.io-index";
          };
        };
        pull = {
          ff = "only";
        };
      };
    };

  };

}

{ pkgs, ... }: {
  system.stateVersion = 5;

  # services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "root" "neuro" ];
  };

  fonts = {
    packages = with pkgs; [
      anonymousPro
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
    ];
  };

  users.users.neuro = {
    name = "neuro";
    home = "/Users/neuro";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.neuro = { pkgs, ... }: {
    home.stateVersion = "22.05";

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];
    home.packages = with pkgs; [
      cachix jq
      tig gh
      mc xz htop
      wget curl
      gmailctl jsonnet
#      rclone restic

      podman qemu
      google-cloud-sdk

      python3 poetry ruff pyright

      openssl
#      (pkgs.callPackage ./ossl.nix { })

#      # Rust: https://github.com/nix-community/fenix
#      (fenix.stable.withComponents [
#        "cargo"
#        "clippy"
#        "rust-src"
#        "rustc"
#        "rustfmt"
#      ])
#      rust-analyzer
    ];

    manual.manpages.enable = false;
    manual.html.enable = false;
    manual.json.enable = false;

    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "Anton Arapov";
      userEmail = "anton@deadbeef.mx";

      ignores = [
        ".DS_Store"
      ];

      signing = {
        key = "134C02E813889057DA2F3FDBEDDD4C5DAA149BBE";
        signByDefault = true;
        signer = "/usr/local/bin/gpg";
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
        pull = { ff = "only"; };
        push = { autoSetupRemote = true; };
      };
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix vim-jsonnet
      ];
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;

      sessionVariables = {
        EDITOR = "vim";
      };
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          #default
        };
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.ssh/id_rsa" ];
          identitiesOnly = true;
        };
        "github.openssl.org" = {
          hostname = "github.openssl.org";
          user = "git";
          identityFile = [ "~/.ssh/id_rsa" ];
          identitiesOnly = true;
        };
      };
    };

  };

}

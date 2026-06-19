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
      roboto
      roboto-mono
      (google-fonts.override { fonts = [ "Newsreader" ]; })
    ];
  };

  users.users.neuro = {
    name = "neuro";
    home = "/Users/neuro";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";
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

      # document/PDF tooling for Claude Code (PDF render+extract, OCR, convert)
      poppler-utils tesseract pandoc qpdf

      podman qemu
      google-cloud-sdk gam

      python3 poetry ruff pyright black
      uv

      nodejs

      openssl gnupg
#      (pkgs.callPackage ./ossl.nix { })

#      # Rust: https://github.com/nix-community/fenix
      (fenix.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer
    ];

    manual.manpages.enable = false;
    manual.html.enable = false;
    manual.json.enable = false;

    programs.git = {
      enable = true;
      lfs.enable = true;
      ignores = [
        ".DS_Store"
        ".claude/"
      ];

      signing = {
        format = "openpgp";
        key = "134C02E813889057DA2F3FDBEDDD4C5DAA149BBE";
        signByDefault = true;
        signer = "/etc/profiles/per-user/neuro/bin/gpg";
      };

      settings = {
        user.name = "Anton Arapov";
        user.email = "anton@deadbeef.mx";

        init.defaultBranch = "master";
        core.editor = "vim";
        core.whitespace = "trailing-space,space-before-tab";
        url."git@github.com:" = {
          pushInsteadOf = "https://github.com/";
        };
 
        pull.ff = "only";
        push.autoSetupRemote = true;
      };
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;

      withRuby = false;
      withPython3 = false;

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

      settings = {
        "*" = {
          #default
        };
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = [ "~/.ssh/id_rsa" ];
          IdentitiesOnly = true;
        };
        "github.openssl.org" = {
          HostName = "github.openssl.org";
          User = "git";
          IdentityFile = [ "~/.ssh/id_rsa" ];
          IdentitiesOnly = true;
        };
      };
    };

  };

}

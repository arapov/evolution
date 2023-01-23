{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "root" "anton" ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      anonymousPro
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.anton = { pkgs, ... }: {
    home.stateVersion = "22.05";

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];

    home.packages = with pkgs; [
      cachix
      git-crypt tig
      mc
      rclone restic
#      openscad

      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer-nightly
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      extensions = (with pkgs.vscode-extensions; [
        eamodio.gitlens
        gruntfuggly.todo-tree
        tamasfe.even-better-toml
        # nix
        bbenoist.nix b4dm4n.vscode-nixpkgs-fmt
        arrterian.nix-env-selector
        # rust
        rust-lang.rust-analyzer
        # vadimcn.vscode-lldb # is broken https://github.com/NixOS/nixpkgs/issues/148946
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
#        {
#          # marus25.cortex-debug
#          publisher = "marus25";
#          name = "cortex-debug";
#          version = "1.6.7";
#          sha256 = "sha256-0xIf+bNUUf1MJtPaNMOwqwyoVhYuHmsjftWjInNlFIo=";
#        }
      ];

      userSettings = {
        "update.mode" = "none";
        "window.titleBarStyle" = "custom";
        "editor.fontFamily" = "FiraCode Nerd Font, Hack Nerd Font, Anonymous Pro";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "editor.rulers" = [80 120];
        "rust-analyzer.trace.server" = "messages";
        "editor.formatOnSave" = true;
#        "lldb.verboseLogging" = true;
#        "lldb.launch.terminal" = "external";
      };
    };

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
      enableAutosuggestions = true;

      sessionVariables = {
        EDITOR = "vim";
      };
    };

    programs.ssh = {
      enable = true;

      extraConfig = ''
        GSSAPIDelegateCredentials yes
      '';

      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.ssh/id_rsa" ];
          identitiesOnly = true;
        };
      };
    };

  };

}

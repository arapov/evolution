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

  users.users.anton = {
    name = "anton";
    home = "/Users/anton";
  };
  environment.pathsToLink = ["/share/qemu"]; # workaround https://discourse.nixos.org/t/out-share-linked-with-nix-profile-install-but-not-otherwise/27561


  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.anton = { pkgs, ... }: {
    home.stateVersion = "22.05";

    home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];
    home.packages = with pkgs; [
      cachix jq
      tig
      mc xz htop
      #broken rclone restic
      podman qemu
      python3 poetry
      #openscad #broken
      openssl
      (pkgs.callPackage ./ossl.nix { })

      # Rust: https://github.com/nix-community/fenix
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

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      extensions = (with pkgs.vscode-extensions; [
        eamodio.gitlens
        gruntfuggly.todo-tree
        tamasfe.even-better-toml
        stkb.rewrap
        # nix
        bbenoist.nix b4dm4n.vscode-nixpkgs-fmt
        arrterian.nix-env-selector
        # rust
        rust-lang.rust-analyzer
        # vadimcn.vscode-lldb # is broken https://github.com/NixOS/nixpkgs/issues/148946
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          # adzero.vscode-sievehighlight
          publisher = "adzero";
          name = "vscode-sievehighlight";
          version = "1.0.6";
          sha256 = "sha256-8Ompv792eI2kIH+5+KPL9jAf88xsMGQewHEQwi8BhoQ=";
        }
        {
          # EmilijanMB.sublime-text-4-theme
          # https://marketplace.visualstudio.com/items?itemName=EmilijanMB.sublime-text-4-theme
          publisher = "EmilijanMB";
          name = "sublime-text-4-theme";
          version = "1.1.2";
          sha256 = "sha256-I1UO8IEq7HKxgH0gVyUN4cdBOouTvsyMgBjPIYQ6E5U=";
        }
        {
          # bierner.github-markdown-preview
          publisher = "bierner";
          name = "github-markdown-preview";
          version = "0.3.0";
          sha256 = "sha256-7pbl5OgvJ6S0mtZWsEyUzlg+lkUhdq3rkCCpLsvTm4g=";
        }
        {
          # bierner.markdown-preview-github-styles
          publisher = "bierner";
          name = "markdown-preview-github-styles";
          version = "2.0.2";
          sha256 = "sha256-GiSS9gCCmOfsBrzahJe89DfyFyJJhQ8tkXVJbfibHQY=";
        }
        {
          # bierner.markdown-footnotes
          publisher = "bierner";
          name = "markdown-footnotes";
          version = "0.1.1";
          sha256 = "sha256-h/Iyk8CKFr0M5ULXbEbjFsqplnlN7F+ZvnUTy1An5t4=";
        }
        {
          # bierner.markdown-checkbox
          publisher = "bierner";
          name = "markdown-checkbox";
          version = "0.4.0";
          sha256 = "sha256-AoPcdN/67WOzarnF+GIx/nans38Jan8Z5D0StBWIbkk=";
        }
        {
          # bierner.markdown-mermaid
          publisher = "bierner";
          name = "markdown-mermaid";
          version = "1.19.0";
          sha256 = "sha256-/uYU/drj4ywFDoXht5sBL/0vktfX9qXNyEN7Wo0zN84=";
        }

      ];

      userSettings = {
        "update.mode" = "none";
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Sublime Text 4 Theme";
        "editor.fontFamily" = "FiraCode Nerd Font, Hack Nerd Font, Anonymous Pro";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "editor.rulers" = [80 120];
        "rust-analyzer.trace.server" = "messages";
        "editor.formatOnSave" = true;
        "markdown-preview-github-styles.colorTheme" = "light";
        "editor.minimap.enabled" = "false";
#        "lldb.verboseLogging" = true;
#        "lldb.launch.terminal" = "external";
      };
    };

    programs.git = {
      enable = true;
      userName = "Anton Arapov";
      userEmail = "anton@deadbeef.mx";

      ignores = [
        ".DS_Store"
      ];

      signing = {
        key = "134C02E813889057DA2F3FDBEDDD4C5DAA149BBE";
        signByDefault = true;
        gpgPath = "/usr/local/bin/gpg";
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

      matchBlocks = {
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

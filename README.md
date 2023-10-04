## evolution - a sample of a darwin system config with nix flakes

Steps to apply this repo:
1. [Install Nix](https://nixos.org/download.html#nix-install-macos): `sh <(curl -L https://nixos.org/nix/install)`
2. Enable [flakes](https://nixos.wiki/wiki/Flakes) by creating and updating `~/.config/nix/nix.conf` file with `experimental-features = nix-command flakes` line.
3. Build this flake: `nix build github:arapov/evolution/main#darwinConfigurations.heimdall.system`
4. And apply it: `./result/sw/bin/darwin-rebuild switch --flake github:arapov/evolution/main`

From now on you can use `darwin-rebuild switch` command to install and/or update packages and system's configuration.
In order to update packages to a recent versions `nix flake update --commit-lock-file` command is useful. :-)

*Configuration in this repo is using `nix-community` flakes, thus enabling and using [Cachix](https://www.cachix.org) will save you some build time. The command to enable it is `cachix use nix-community`.*

## cachix
```
$ nix build .#darwinConfigurations.heimdall.system --json \
  | jq -r '.[].outputs | to_entries[].value' \
  | cachix push arapov
```


## evolution - a sample of a darwin system config with nix flakes

Steps to apply this repo:
1. [Install Nix](https://nixos.org/download.html#nix-install-macos): `sh <(curl -L https://nixos.org/nix/install)`
2. Enable [flakes](https://nixos.wiki/wiki/Flakes) by creating and updating `~/.config/nix/nix.conf` file with `experimental-features = nix-command flakes` line.
3. You need to create `/run` directory in the root filesystem:
```
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf 
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
```
4. Now you ready to build this flake: `nix build github:arapov/evolution/main#darwinConfigurations.heimdall.system`
5. And apply it: `./result/sw/bin/darwin-rebuild switch --flake github:arapov/evolution/main`

*In case you've got a warning that `/etc/nix/nix.conf` exists. Just rename it or move it somewhere else. `darwin-rebuild` will re-create it as it is managed by the tool itself.*

From now on you can use `darwin-rebuild switch` command to install and/or update packages and system's configuration.
In order to update packages to a recent versions `nix flake update --commit-lock-file` command is useful. :-)

*Configuration in this repo is using `nix-community` flakes, thus enabling and using [Cachix](https://www.cachix.org) will save you some build time. The command to enable it is `cachix use nix-community`.*  

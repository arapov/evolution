## evolution - a sample of a darwin system config with nix flakes

Install Nix
> sh <(curl -L https://nixos.org/nix/install)

Create and update a `~/.config/nix/nix.conf` file with the following line
> experimental-features = nix-command flakes

Next we need to create `/run` directory in the root filesystem
```
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf 
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
```

Build this flake
> nix build github:arapov/evolution/main#darwinConfigurations.heimdall.system

Then execute `./result/sw/bin/darwin-rebuild switch --flake github:arapov/evolution/main`

In case you've got a warning that `/etc/nix/nix.conf` exists. Just rename it or move it somewhere else. `darwin-rebuild` will re-create as it is managed by `darwin-rebuild` itself.

From now on you can use `darwin-rebuild switch` command to install and/or update packages and system's configuration.
In order to update packages to a recent versions `nix flake update --commit-lock-file` command is useful. :-)

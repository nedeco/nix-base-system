# `nix` Base System

Base system configuration for development machines.

This repository provides [`nix-darwin`](https://github.com/nix-darwin/nix-darwin) and [`home-manager`](https://github.com/nix-community/home-manager)
modules with base configurations for multiple tools and programs used for developing customer projects.

## Profiles

### `nix-darwin`

* `standard`: The standard profile used on all development machines

#### Options

`config.nedeco` provides the following attributes:

```
documentation.enable
nix.enable
sudo.enable
update-changelog.enable
zsh.enable
```

Profiles just automatically enable a given set of these options.

Enabling an option essentially just automatically configures a part of `nix-darwin`.

### `home-manager`

* `empty`: An empty profile that is used to make program-specific options available without enabling them
* `minimal`: The minimal set of programs that _should_ be enabled on all development machines

#### Options

`config.nedeco` provides the following attributes:

```
cli-tools.enable
direnv.enable
git.enable
zsh.enable
```

Profiles just automatically enable a given set of these options.

Enabling an option essentially just automatically configures a part of `home-manager`.

## Installation

Install `lix` as described [here](https://lix.systems/install/#on-any-other-linuxmacos-system). Make sure you enable Flakes during installation.

This assumes that you do not have an existing installation of `nix` (or specifically `lix`).
If you already have an existing `nix` or `lix` installation, you can skip this step.

The rest of these steps assume that you don't have an existing configuration. If you do, you're on your own.

```
mkdir -p ~/.config/nixpkgs/
cd ~/.config/nixpkgs/
nix flake init -t "github:nedeco/nix-base-system#standard"
find . -type f -name "*.nix" -exec sed -I '' "s/%SYSTEM_CURRENT_USER%/$(id -un)/g" {} +
find . -type f -name "*.nix" -exec sed -I '' "s/%SYSTEM_CURRENT_NAME%/$(id -F)/g" {} +
nix run nix-darwin/master#darwin-rebuild -- --flake '.#default' switch
```

The last command can potentially take some time to run, because it has to download (or compile) all of the configured programs and utilities.

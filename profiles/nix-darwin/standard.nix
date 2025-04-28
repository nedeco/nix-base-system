{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [ ../../programs/nix-darwin ];

  nedeco = {
    documentation.enable = mkDefault true;
    nix.enable = mkDefault true;
    sudo.enable = mkDefault true;
    update-changelog.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}

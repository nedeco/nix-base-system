{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../programs/home-manager
    ./minimal.nix
  ];

  nedeco = {
    ghostty.enable = mkDefault true;
    linkapps.enable = mkDefault true;
  };
}

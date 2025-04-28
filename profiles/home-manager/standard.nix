{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../programs/home-manager
    ./minimal.nix
  ];
}

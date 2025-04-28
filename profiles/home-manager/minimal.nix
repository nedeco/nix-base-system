{ lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  imports = [ ../../programs/home-manager ];

  nedeco = {
    cli-tools.enable = mkDefault true;
    direnv.enable = mkDefault true;
    git.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}

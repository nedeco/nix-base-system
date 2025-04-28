{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.cli-tools;
in
{
  options.nedeco.cli-tools = {
    enable = lib.mkEnableOption "nedeco.cli-tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password-cli
      curl
      dig
      fd
      hexyl
      just
      lnav
      mtr
      ripgrep
      wget
    ];
  };
}

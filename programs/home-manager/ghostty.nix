{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.ghostty;
in
{
  options.nedeco.ghostty = {
    enable = lib.mkEnableOption "nedeco.ghostty";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        command = "${pkgs.zsh.outPath}/bin/zsh";
      };
    };
  };
}

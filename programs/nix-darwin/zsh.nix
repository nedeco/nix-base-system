{
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.zsh;
in
{
  options.nedeco.zsh = {
    enable = lib.mkEnableOption "nedeco.zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
  };
}

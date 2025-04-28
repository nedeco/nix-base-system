{
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.direnv;
in
{
  options.nedeco.direnv = {
    enable = lib.mkEnableOption "nedeco.direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = {
        strict_env = true;
        warn_timeout = "1m";
        hide_env_diff = true;
      };

      stdlib = builtins.readFile ./direnvrc;
    };
  };
}

{
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.sudo;
in
{
  options.nedeco.sudo = {
    enable = lib.mkEnableOption "nedeco.sudo";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      watchIdAuth = true;
    };
  };
}

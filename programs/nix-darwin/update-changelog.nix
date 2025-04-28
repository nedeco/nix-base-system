{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.update-changelog;
in
{
  options.nedeco.update-changelog = {
    enable = lib.mkEnableOption "nedeco.update-changelog";
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.postActivation.text = ''
      if [[ -e /run/current-system ]]; then
        echo "[update-changelog] System Changelog"
        sudo -H ${lib.getExe pkgs.nvd} --nix-bin-dir='${config.nix.package}/bin' diff /run/current-system "$systemConfig"
      fi
    '';
  };
}

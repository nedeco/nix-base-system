{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.linkapps;
in
{
  options.nedeco.linkapps = {
    enable = lib.mkEnableOption "nedeco.linkapps";
  };

  disabledModules = lib.optionals cfg.enable [ "targets/darwin/linkapps.nix" ];

  config = lib.mkIf cfg.enable {
    home = rec {
      packages = [ ];

      activation.aliasApplications =
        let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = packages;
            pathsToLink = "/Applications";
          };

          lastAppsFile = "${config.xdg.stateHome}/nix/.apps";
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
          ''
            last_apps=$(cat "${lastAppsFile}" 2>/dev/null || echo "")
            next_apps=$(readlink -f ${apps}/Applications/* | sort)

            if [ "$last_apps" != "$next_apps" ]; then
              echo "Apps have changed. Updating macOS aliases..."

              apps_path="$HOME/Applications/Home Manager Apps"
              $DRY_RUN_CMD mkdir -p "$apps_path"

              $DRY_RUN_CMD ${lib.getExe pkgs.fd} \
                -t l -d 1 . ${apps}/Applications \
                -x $DRY_RUN_CMD "${pkgs.mkalias}/bin/mkalias" \
                -L {} "$apps_path/{/}"

              [ -z "$DRY_RUN_CMD" ] && echo "$next_apps" > "${lastAppsFile}"
            fi
          '';
    };
  };
}

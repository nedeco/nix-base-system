{
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.nix;
in
{
  options.nedeco.nix = {
    enable = lib.mkEnableOption "nedeco.nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        log-lines = 25;
        keep-derivations = true;
        keep-outputs = true;

        substituters = [
          "https://nix-community.cachix.org?priority=50"
          "https://cache.lix.systems?priority=70"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        ];

        trusted-users = [ "@admin" ];

        connect-timeout = 5;
      };

      optimise = {
        automatic = true;
      };

      gc = {
        automatic = true;
        interval = {
          Weekday = 0;
          Hour = 3;
          Minute = 15;
        };
      };
    };

    services = {
      nix-daemon = {
        logFile = "/var/log/nix-daemon.log";
      };
    };
  };
}

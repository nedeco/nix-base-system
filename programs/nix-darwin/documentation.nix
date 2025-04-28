{
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.documentation;
in
{
  options.nedeco.documentation = {
    enable = lib.mkEnableOption "nedeco.documentation";
  };

  config = lib.mkIf cfg.enable {
    documentation.doc.enable = false;
  };
}

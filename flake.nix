{
  outputs =
    { self }:
    {
      darwinModules = {
        standard = import ./profiles/nix-darwin/standard.nix;
      };

      homeManagerModules = {
        empty = import ./profiles/home-manager/empty.nix;
        minimal = import ./profiles/home-manager/minimal.nix;
        standard = import ./profiles/home-manager/standard.nix;
      };

      templates = {
        standard = {
          path = ./templates/standard;
          description = "A standard development machine template";
        };
      };
    };
}

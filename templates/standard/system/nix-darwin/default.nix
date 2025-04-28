{
  nixpkgs,
  lix-module,
  home-manager,
  nix-darwin,
  agenix,
  mkalias,
  nedeco,
}:

let
  default-system = "aarch64-darwin";

  overlay-mkalias = _: _: { inherit (mkalias.packages.${default-system}) mkalias; };

  nixpkgsConfig = {
    overlays = [
      agenix.overlays.default
      overlay-mkalias
    ];

    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
in
nix-darwin.lib.darwinSystem {
  system = default-system;
  modules = [
    {
      nixpkgs = nixpkgsConfig;
      nix = {
        registry.nixpkgs.to = {
          type = "path";
          path = nixpkgs.outPath;
        };
        nixPath = nixpkgs.lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
      };
    }

    lix-module.nixosModules.default

    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        sharedModules = [ nedeco.homeManagerModules.standard ];

        users."%SYSTEM_CURRENT_USER%" = import ../../customization/home-manager;
      };
    }

    agenix.darwinModules.default

    nedeco.darwinModules.standard

    ../../customization/nix-darwin
  ];
}

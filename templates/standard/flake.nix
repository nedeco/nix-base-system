{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Lix

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=release-2.92";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tools

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-root.url = "github:srid/flake-root";

    # Overlays

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "nix-darwin";
        home-manager.follows = "home-manager";
      };
    };

    mkalias = {
      url = "github:reckenrode/mkalias";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nedeco.url = "github:nedeco/nix-base-system";
  };

  outputs =
    inputs@{
      flake-parts,
      lix-module,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake =
        let
          system = import ./system/nix-darwin {
            inherit (inputs)
              nixpkgs
              home-manager
              nix-darwin
              agenix
              mkalias
              nedeco
              ;
            inherit lix-module;
          };
        in
        {
          darwinConfigurations = {
            default = system;
          };
        };

      imports = [
        inputs.flake-root.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          inputs',
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            name = "nedeco-standard";

            inputsFrom = [
              config.flake-root.devShell
            ];

            packages = [
              inputs'.agenix.packages.agenix
              pkgs.just
              pkgs.nix-output-monitor
            ];
          };
        };
    };
}

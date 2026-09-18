{
  description = "IW1 – Desktop systémy Microsoft Windows: přednášky (Marp) a počítačová cvičení";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      h = inputs.haumea.lib;

      nixpkgsConfig = {
        config.allowUnfree = true;
      };

      customLib = import ./lib { inherit lib inputs h; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # Everything under ./nix is a flake-parts module (auto-loaded by haumea).
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
      ]
      ++ (lib.collect builtins.isPath (
        h.load {
          src = ./nix;
          loader = h.loaders.path;
        }
      ));

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = {
        lib = customLib;
      };

      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = import inputs.nixpkgs (nixpkgsConfig // { inherit system; });

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };
        };
    };
}

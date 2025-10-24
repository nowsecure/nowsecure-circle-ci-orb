{
  description = "NowSecure CircleCI Orb flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:

    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {

        # Development environments
        devShells = pkgs.mkShell {
          default = pkgs.mkShell {

            packages = [
              pkgs.nixpkgs-fmt
              pkgs.nil

              pkgs.circleci-cli
            ];

          };
        };
      }
    );
}

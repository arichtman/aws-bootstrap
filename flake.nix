{
  description = "aws-bootstrap";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:arichtman/poetry2nix/rdflib-poetry";
  };
  outputs = {
    self,
    nixpkgs,
    poetry2nix,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv ;
        poetryEnv = mkPoetryEnv {
          projectDir = ./.;
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              terraform
              terragrunt
              awscli2
              poetry
              dig
              infracost
              poetryEnv
              checkov
            ];
            shellHook = ''
              pre-commit install --install-hooks
            '';
          };
      }
    );
}

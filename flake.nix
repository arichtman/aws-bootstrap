{
  description = "aws-bootstrap";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";
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
          config.allowUnfree = true; # Required for Terraform BSL
          overlays = [poetry2nix.overlays.default];
        };
        poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          preferWheels = true;
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

# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    poetry2nix,
    terranix,
    flake-utils,
    ...
  } @ inputs:
  #TODO: See about restricting systems to x86_64-{linux,darwin}
    flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        #TODO: Why can't we access inputs.poetry2nix.mkPoetryEnv directly?
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        poetryEnv = mkPoetryEnv {
          projectDir = ./.;
        };
        moduleToUse = import ./module.nix;
        moduleOutput = moduleToUse { environment = "prod"; } ;
        envs = import ./environments.nix;
      in {
        devShells.default = with pkgs;
          mkShell {
            nativeBuildInputs = [
              poetryEnv
              terraform
              terragrunt
              awscli2
              poetry
              infracost
              alejandra
              checkov
            ];
            shellHook = ''
              pre-commit install --install-hooks
              echo ${envs.prod.name}
              echo ${moduleOutput.stringOut}
            '';
          };
        defaultPackage = terranix.lib.terranixConfiguration {
          inherit system;
          modules = [./config.nix];
        };
      }
    );
}

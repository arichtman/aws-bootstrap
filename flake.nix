# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.terranix = {
    url = "github:terranix/terranix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, poetry2nix , terranix, ... }:
      let
        pkgs = import nixpkgs {
        };
        system = "x86_64-linux";
        poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            poetryEnv
            terraform
            terragrunt
            awscli2
            poetry
          ];
          shellHook = ''
            . <(terraform-docs completion bash)
            pre-commit install --install-hooks
          '';
        };
        defaultPackage.x86_64-linux = terranix.lib.terranixConfiguration {
          inherit system;
          modules = [ ./config.nix ];
        };
      };
}

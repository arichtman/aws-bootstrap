# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "IaC using Nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.terranix = {
    url = "github:terranix/terranix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, poetry2nix , terranix, flake-utils, ... }:
      flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
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
          defaultPackage = terranix.lib.terranixConfiguration {
            inherit system;
            modules = [ ./config.nix ];
          };
        }
      );
}

# Reference https://discourse.nixos.org/t/easy-install-pypi-python-packages-mach-nix-poetry2nix/23825/6
{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    {
      # Nixpkgs overlay providing the application
      overlay = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: prev: {
          poetry2nix = prev.poetry2nix.overrideScope' (p2nixfinal: p2nixprev: {
            # pyfinal & pyprev refers to python packages
            defaultPoetryOverrides = (p2nixprev.defaultPoetryOverrides.extend (pyfinal: pyprev:
              {
                ## dodge infinite recursion ##
                setuptools = prev.python310Packages.setuptools.override {
                  inherit (pyfinal)
                    bootstrapped-pip
                    pipInstallHook
                    setuptoolsBuildHook
                  ;
                };

                setuptools-scm = prev.python310Packages.setuptools-scm.override {
                  inherit (pyfinal)
                    packaging
                    typing-extensions
                    tomli
                    setuptools;
                };

                pip = prev.python310Packages.pip.override {
                  inherit (pyfinal)
                    bootstrapped-pip
                    mock
                    scripttest
                    virtualenv
                    pretend
                    pytest
                    pip-tools
                  ;
                };
                ## dodge infinite recursion (end) ##

                bc-jsonpath-ng = pyprev.bc-jsonpath-ng.overridePythonAttrs (old: rec {
                  propagatedBuildInputs = builtins.filter (x: ! builtins.elem x [ ]) ((old.propagatedBuildInputs or [ ]) ++ [
                    pyfinal.setuptools
                  ]);
                });
                bc-detect-secrets = pyprev.bc-detect-secrets.overridePythonAttrs (old: rec {
                  propagatedBuildInputs = builtins.filter (x: ! builtins.elem x [ ]) ((old.propagatedBuildInputs or [ ]) ++ [
                    pyfinal.setuptools
                  ]);
                });
              }
            ));
          });
        })
        (final: prev: {
          # The application
          myapp = prev.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
          };
          # The env
          myenv = prev.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
          };
        })
      ];
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      {
        packages.poetry = nixpkgs.legacyPackages.${system}.python310Packages.poetry;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            myenv
            terraform
            terragrunt
            awscli2
            poetry
          ];
        };
      }));
}

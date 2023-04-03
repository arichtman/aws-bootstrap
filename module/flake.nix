{
  description = "IaC using Nix";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.terranix = {
    url = "github:terranix/terranix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    terranix,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    moduleToUse = import ./minimal;
    envs = import ./environments;
    # moduleOutput = moduleToUse.mkDeployment envs.prod.name ( builtins.elemAt envs.prod.stages 0) "seatmap.net.au";
    partialFunction = x: y: moduleToUse.mkDeployment envs.prod.name;
    moduleOutput = map partialFunction ( builtins.attrNames envs.prod.stages );
    finalOutput =( builtins.groupBy builtins.attrNames  moduleOutput);
  in {
    devShells.default = with pkgs;
      mkShell {
        nativeBuildInputs = [
          terraform
          terragrunt
          awscli2
          infracost
          alejandra
        ];
        shellHook = ''
          echo ${envs.prod.name}
          echo ${moduleOutput.stringOut}
        '';
      };
    packages.${system}.default = terranix.lib.terranixConfiguration {
      inherit system;
      modules = [ finalOutput ];
    };
  };
}

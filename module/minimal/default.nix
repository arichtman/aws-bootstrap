let
  # TODO: This needs to be a utility library somewhere
  # TODO: This needs to handle way more character variation on input
  # TODO: This needs to truncate
  # TODO: See about using another approach that doesn't require duplication on the second array
  slugify = inputString: ( builtins.replaceStrings [ "." "+" ] (builtins.genList (x: "_") 2) inputString );
  mkRoute53Zone = name:
  let
    slugifiedName = slugify name;
  in {
    resource.aws_route53_zone.${slugifiedName} = {
      name = "${name}";
    };
  };
  mkDeployment = env: stage: app: mkRoute53Zone "${env}_${stage}_${app}";
in {
  mkDeployment = mkDeployment;
}

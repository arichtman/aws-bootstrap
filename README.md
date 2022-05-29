# aws-bootstrap

Bootstrap layer Terraform module

podman run --rm -it -v $HOME/.aws:/conf/.aws --entrypoint /bin/ash cloudposse/geodesic:latest-alpine

podman run --rm -it -v $HOME/.aws:/root/.aws amazon/aws-cli sts get-caller-identity

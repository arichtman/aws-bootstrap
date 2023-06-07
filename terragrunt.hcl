
generate "provider" {
    path = "_provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
EOF
}

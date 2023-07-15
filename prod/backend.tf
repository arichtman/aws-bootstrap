terraform {
  required_version = ">= 1"

  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "state-terraform-richtman-au"
    key            = "prod.tfstate"
    dynamodb_table = "state-lock-terraform"
    profile        = "root"
    encrypt        = "true"
  }
}

terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "state-terraform-richtman-au"
    key            = "nonprod.tfstate"
    dynamodb_table = "state-lock-terraform"
    profile        = "root"
    encrypt        = "true"
  }
}

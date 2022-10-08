
provider "aws" {
  region  = "ap-southeast-2"
  profile = "prod-pu"
  alias   = "ap-southeast-2"
}

# Required due to Cloudfront ACM cert region requirements
# Unfortunately, even removing the profile and default region specifications
#  in ~/.aws/config it still seems to lock our login to the region
#  For now an addional profile will suit as I'm working solo and don't need do x-region much
# Update: it refuses to let me sso login to another region using this profile/SSO user
#  Error is: invalid_grant Invalid grant provided
# I'm wondering if I should just port to IAM Identity Centre... Probably...
#  Oh look, there's no modules for it that and it has token expiry issues with the CLI
# >:( Parking for now on this branch.
provider "aws" {
  region  = "us-east-1"
  profile = "prod-pu-ue1"
  alias   = "us-east-1"
}


module "website_with_cname" {
  source = "cloudposse/s3-website/aws"
  version = "0.17.3"
  namespace      = "richtman"
  stage          = "prod"
  name           = "www"
  hostname       = "richtman.com.au"
  parent_zone_id = "Z01826163D3VRAU0A0WO0"
  logs_enabled = false
  versioning_enabled = false
}

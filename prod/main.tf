
module "website_with_cname" {
  source             = "cloudposse/s3-website/aws"
  version            = "0.17.3"
  namespace          = "richtman"
  stage              = "prod"
  name               = "www"
  hostname           = "www.richtman.com.au"
  parent_zone_id     = "Z08116791P4Y5U5XR8XQX"
  logs_enabled       = false
  versioning_enabled = false
}

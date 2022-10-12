
module "website_with_cname" {
  # source             = "cloudposse/s3-website/aws"
  # version            = "0.17.3"
  # Waiting on PR review, merge, release
  # It also don't like the forward slash in the ref
  source             = "github.com/cloudposse/terraform-aws-s3-website?ref=feature%2Faws-v4-support"
  namespace          = "richtman-com-au"
  hostname           = "richtman.com.au"
  parent_zone_id     = "Z08116791P4Y5U5XR8XQX"
  logs_enabled       = false
  versioning_enabled = false
}

resource "aws_s3_object" "richtman_com_au_index_html" {
  bucket       = module.website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "richtman_com_au_404_html" {
  bucket       = module.website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "404.html"
  content_type = "text/html"
}

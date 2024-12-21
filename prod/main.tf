
module "old_website_with_cname" {
  # source             = "cloudposse/s3-website/aws"
  # version            = "0.17.3"
  # Waiting on PR review, merge, release
  # It also don't like the forward slash in the ref
  # source             = "github.com/cloudposse/terraform-aws-s3-website?ref=feature%2Faws-v4-support"
  source             = "github.com/cloudposse/terraform-aws-s3-website?ref=af6613f0a2dc0ac992c5bf43c81b952a4b4c7e59"
  namespace          = "richtman-com-au"
  hostname           = "richtman.com.au"
  parent_zone_id     = aws_route53_zone.richtman_com_au.zone_id
  logs_enabled       = false
  versioning_enabled = false
}

resource "aws_s3_object" "richtman_com_au_index_html" {
  bucket       = module.old_website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "richtman_com_au_404_html" {
  bucket       = module.old_website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "404.html"
  content_type = "text/html"
}

module "website_with_cname" {
  # Changes to bucket defaults are now causing failures
  # Ref: https://github.com/cloudposse/terraform-aws-s3-website/issues/84
  # I still had to hack in .terraform in the versions.tf to unset AWS < 4.0.0
  #  cause there's no fork/PR that fixes both
  source                   = "github.com/JohnShortland/terraform-aws-s3-website"
  namespace                = "richtman-au"
  hostname                 = "richtman.au"
  parent_zone_id           = aws_route53_zone.richtman_au.zone_id
  logs_enabled             = false
  versioning_enabled       = false
  redirect_all_requests_to = "www.richtman.au"
}

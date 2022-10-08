
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
  bucket = module.website_with_cname.s3_bucket_name
  source = "assets/redirect.html"
  key    = "index.html"
}

resource "aws_s3_object" "richtman_com_au_404_html" {
  bucket = module.website_with_cname.s3_bucket_name
  source = "assets/redirect.html"
  key    = "404.html"
}


module "acm_request_certificate_richtman_com_au" {
  source = "cloudposse/acm-request-certificate/aws"
  providers = {
    aws = aws.us-east-1
  }

  version     = "v0.17.0"
  domain_name = "richtman.com.au"
  # subject_alternative_names         = ["a.example.com", "b.example.com", "*.c.example.com"]
  zone_id                           = resource.aws_route53_zone.richtman_com_au.zone_id
  process_domain_validation_options = true
  ttl                               = "3600"
}

module "cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version   = "v0.83.0"
  namespace = "richtman-com-au"
  # name              = "app"
  aliases           = ["assets.cloudposse.com"]
  dns_alias_enabled = true
  parent_zone_name  = "cloudposse.com"

  acm_certificate_arn = module.acm_request_certificate_richtman_com_au.arn

  # depends_on = [module.acm_request_certificate_richtman_com_au]
}

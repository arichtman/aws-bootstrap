
module "website_with_cname" {
  source                   = "github.com/cloudposse/terraform-aws-s3-website"
  namespace                = "richtman-au"
  hostname                 = "richtman.au"
  parent_zone_id           = aws_route53_zone.richtman_au.zone_id
  logs_enabled             = false
  versioning_enabled       = false
  redirect_all_requests_to = "www.richtman.au"
}

resource "aws_s3_object" "richtman_au_index_html" {
  bucket       = module.website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "richtman_au_404_html" {
  bucket       = module.website_with_cname.s3_bucket_name
  source       = "assets/redirect.html"
  key          = "404.html"
  content_type = "text/html"
}

resource "aws_s3_object" "richtman_au_root_ca" {
  bucket       = module.website_with_cname.s3_bucket_name
  source       = "assets/root-ca.pem"
  key          = "root-ca.pem"
  content_type = "binary/octet-stream"
}

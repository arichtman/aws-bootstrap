
resource "aws_route53_zone" "richtman_au" {
  name = "richtman.au"
}

resource "aws_route53_record" "richtman_au_nameservers" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "${aws_route53_zone.richtman_au.name}."
  type    = "NS"
  ttl     = 172800
  records = [
    "${aws_route53_zone.richtman_au.name_servers[0]}",
    "${aws_route53_zone.richtman_au.name_servers[1]}",
    "${aws_route53_zone.richtman_au.name_servers[2]}",
    "${aws_route53_zone.richtman_au.name_servers[3]}",
  ]
}

resource "aws_route53_record" "richtman_au_soa" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "${aws_route53_zone.richtman_au.name}."
  type    = "SOA"
  ttl     = 3600
  records = [
    "${aws_route53_zone.richtman_au.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

module "richtman_au_migadu_domain" {
  source                        = "arichtman/migadu-email-domain/aws"
  version                       = ">= 0.3.0"
  route53_zone_name             = aws_route53_zone.richtman_au.name
  migadu_domain_verification_id = "qexlpkpy"
  merge_apex_text_records       = true
  depends_on                    = [aws_route53_record.richtman_au_TXT_keybase]
}

# Delegate zone for subdomain to Netlify so they can serve valid TLS certificates for custom domain
resource "aws_route53_record" "www_richtman_au_nameservers" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "www.richtman.au"
  type    = "NS"
  ttl     = 172800
  records = [
    "dns1.p03.nsone.net",
    "dns2.p03.nsone.net",
    "dns3.p03.nsone.net",
    "dns4.p03.nsone.net",
  ]
}
# Delegate zone for subdomain to Netlify so they can serve valid TLS certificates for custom domain
resource "aws_route53_record" "food_richtman_au_nameservers" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "food.richtman.au"
  type    = "NS"
  ttl     = 172800
  records = [
    "dns1.p01.nsone.net",
    "dns2.p01.nsone.net",
    "dns3.p01.nsone.net",
    "dns4.p01.nsone.net",
  ]
}

resource "aws_route53_record" "richtman_au_TXT_keybase" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "${aws_route53_zone.richtman_au.name}."
  type    = "TXT"
  ttl     = 3600
  records = [
    "keybase-site-verification=50IPtg1CA_Rs-b7u-V1JXLguFPSMaPJIE0VVA-wb1AQ",
  ]
  # Required as it's an apex record and migadu injects some there
  lifecycle {
    ignore_changes = [
      records,
    ]
  }
}

resource "aws_route53_record" "ariel_richtman_au_TXT_bluesky" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_atproto.ariel.${aws_route53_zone.richtman_au.name}."
  type    = "TXT"
  ttl     = 3600
  records = [
    "did=did:plc:cooifaem6deemdxqivl6uwga",
  ]
}

resource "aws_route53_record" "nextcloud_richtman_au_cname" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "nextcloud.${aws_route53_zone.richtman_au.name}."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "nx43916.your-storageshare.de.",
  ]
}

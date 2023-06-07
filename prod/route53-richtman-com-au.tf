
resource "aws_route53_zone" "richtman_com_au" {
  name = "richtman.com.au"
}

resource "aws_route53_record" "richtman_com_au_nameservers" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "${aws_route53_zone.richtman_com_au.name}."
  type    = "NS"
  ttl     = 172800
  records = [
    "${aws_route53_zone.richtman_com_au.name_servers[0]}",
    "${aws_route53_zone.richtman_com_au.name_servers[1]}",
    "${aws_route53_zone.richtman_com_au.name_servers[2]}",
    "${aws_route53_zone.richtman_com_au.name_servers[3]}",
  ]
}

# Delegate zone for subdomain to Netlify so they can serve valid TLS certificates for custom domain
resource "aws_route53_record" "www_richtman_com_au_nameservers" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "www.richtman.com.au"
  type    = "NS"
  ttl     = 172800
  records = [
    "dns1.p01.nsone.net",
    "dns2.p01.nsone.net",
    "dns3.p01.nsone.net",
    "dns4.p01.nsone.net",
  ]
}

resource "aws_route53_record" "richtman_com_au_soa" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "${aws_route53_zone.richtman_com_au.name}."
  type    = "SOA"
  ttl     = 3600
  records = [
    "${aws_route53_zone.richtman_com_au.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

module "richtman_com_au_migadu_domain" {
  source                        = "arichtman/migadu-email-domain/aws"
  route53_zone_name             = aws_route53_zone.richtman_com_au.name
  migadu_domain_verification_id = "6hp6vnj8"
}

# Delegate zone for subdomain to Netlify so they can serve valid TLS certificates for custom domain
resource "aws_route53_record" "food_richtman_com_au_nameservers" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "food.richtman.com.au"
  type    = "NS"
  ttl     = 172800
  records = [
    "dns1.p01.nsone.net",
    "dns2.p01.nsone.net",
    "dns3.p01.nsone.net",
    "dns4.p01.nsone.net",
  ]
}
# Delegate zone for subdomain to Netlify so they can serve valid TLS certificates for custom domain
resource "aws_route53_record" "icalendar-leave-optimiser_richtman_com_au_nameservers" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "icalendar-leave-optimiser.richtman.com.au"
  type    = "NS"
  ttl     = 172800
  records = [
    "dns1.p01.nsone.net",
    "dns2.p01.nsone.net",
    "dns3.p01.nsone.net",
    "dns4.p01.nsone.net",
  ]
}


resource "aws_route53_zone" "richtman_id_au" {
  name = "richtman.id.au"
}

resource "aws_route53_record" "richtman_id_au_nameservers" {
  zone_id = aws_route53_zone.richtman_id_au.zone_id
  name    = "${aws_route53_zone.richtman_id_au.name}."
  type    = "NS"
  ttl     = 172800
  records = [
    "${aws_route53_zone.richtman_id_au.name_servers[0]}",
    "${aws_route53_zone.richtman_id_au.name_servers[1]}",
    "${aws_route53_zone.richtman_id_au.name_servers[2]}",
    "${aws_route53_zone.richtman_id_au.name_servers[3]}",
  ]
}

resource "aws_route53_record" "richtman_id_au_soa" {
  zone_id = aws_route53_zone.richtman_id_au.zone_id
  name    = "${aws_route53_zone.richtman_id_au.name}."
  type    = "SOA"
  ttl     = 3600
  records = [
    "${aws_route53_zone.richtman_id_au.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

module "richtman_id_au_migadu_domain" {
  source                        = "arichtman/migadu-email-domain/aws"
  version                       = ">= 0.3.0"
  route53_zone_name             = aws_route53_zone.richtman_id_au.name
  migadu_domain_verification_id = "wve23ado"
}

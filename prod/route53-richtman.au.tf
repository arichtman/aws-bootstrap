
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

resource "aws_route53_record" "richtman_au_TXT" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "richtman.au"
  type    = "TXT"
  ttl     = 3600
  records = [
    "v=spf1 -all",
  ]
}

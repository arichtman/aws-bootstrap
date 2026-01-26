
resource "aws_route53_zone" "systems_richtman_au" {
  name = "systems.richtman.au"
}

resource "aws_route53_record" "systems_richtman_au_nameservers" {
  zone_id = aws_route53_zone.systems_richtman_au.zone_id
  name    = "${aws_route53_zone.systems_richtman_au.name}."
  type    = "NS"
  ttl     = 172800
  records = aws_route53_zone.systems_richtman_au.name_servers
}

resource "aws_route53_record" "systems_richtman_au_soa" {
  zone_id = aws_route53_zone.systems_richtman_au.zone_id
  name    = "${aws_route53_zone.systems_richtman_au.name}."
  type    = "SOA"
  ttl     = 3600
  records = [
    "${aws_route53_zone.systems_richtman_au.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

locals {
  systems = {
    fat-controller = "2403:580a:e4b1:0:aab8:e0ff:fe00:91f0"
    dr-singh       = "2403:580a:e4b1:0:2580:8617:e287:5fc7"
    patient-zero   = "2403:580a:e4b1:0:1262:e5ff:fe00:b20d"
    smol-bat       = "2403:580a:e4b1:0:1262:e5ff:fe02:9b6"
    tweedledee     = "2403:580a:e4b1:0:ed66:b6d1:84a4:b35c"
    tweedledum     = "2403:580a:e4b1:0:2123:3ebd:5d16:67d7"
  }
}

resource "aws_route53_record" "machines_systems_richtman_au_aaaa" {
  for_each        = local.systems
  zone_id         = aws_route53_zone.systems_richtman_au.zone_id
  name            = "${each.key}.${aws_route53_zone.systems_richtman_au.name}."
  type            = "AAAA"
  ttl             = 3600
  records         = [each.value]
  allow_overwrite = true
}

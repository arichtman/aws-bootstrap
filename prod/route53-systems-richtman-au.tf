
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
  prefix = "2403:581e:ab78"
  eui64 = {
    fat-controller = "aab8:e0ff:fe00:91f0"
    dr-singh       = "1262:e5ff:fe00:61a3"
    patient-zero   = "1262:e5ff:fe00:b20d"
    smol-bat       = "1262:e5ff:fe02:9b6"
    tweedledee     = "223:24ff:fea0:decc"
    tweedledum     = "dacb:8aff:fe5f:9774"
  }
  systems = { for hostname, eui64 in local.eui64 : hostname => "${local.prefix}:0:${eui64}" }
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

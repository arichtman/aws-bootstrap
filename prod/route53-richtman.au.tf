
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
    "hosted-email-verify=qexlpkpy",
    "v=spf1 include:spf.migadu.com -all",
  ]
}

resource "aws_route53_record" "richtman_au_MX" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "richtman.au"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 aspmx1.migadu.com",
    "20 aspmx2.migadu.com",
  ]
}

resource "aws_route53_record" "richtman_au_migadu_domainkeys_CNAME" {
  count   = 4
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "key${count.index}._domainkey.richtman.au."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "key${count.index}.richtman.au._domainkey.migadu.com.",
  ]
}

resource "aws_route53_record" "richtman_au_dmarc_TXT" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_dmarc.richtman.au."
  type    = "TXT"
  ttl     = 3600
  records = [
    "v=DMARC1; p=quarantine",
  ]
}

resource "aws_route53_record" "richtman_au_subdomain_MX" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "*.richtman.au"
  type    = "MX"
  ttl     = 3600
  records = [
    "10 aspmx1.migadu.com",
    "20 aspmx2.migadu.com",
  ]
}

resource "aws_route53_record" "richtman_au_autoconfig_CNAME" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "autoconfig"
  type    = "CNAME"
  ttl     = 3600
  records = [
    "autoconfig.migadu.com.",
  ]
}

resource "aws_route53_record" "richtman_au_autodiscover_SRV" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_autodiscover._tcp.richtman.au"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 443 autodiscover.migadu.com",
  ]
}
resource "aws_route53_record" "richtman_au_submissions_SRV" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_submissions._tcp.richtman.au"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 465 smtp.migadu.com",
  ]
}
resource "aws_route53_record" "richtman_au_imaps_SRV" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_imaps._tcp.richtman.au"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 993 imap.migadu.com",
  ]
}
resource "aws_route53_record" "richtman_au_pop3s_SRV" {
  zone_id = aws_route53_zone.richtman_au.zone_id
  name    = "_pop3s._tcp.richtman.au"
  type    = "SRV"
  ttl     = 3600
  records = [
    "0 1 995 pop.migadu.com",
  ]
}

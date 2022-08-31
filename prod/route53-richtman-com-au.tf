
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
resource "aws_route53_record" "blog_richtman_com_au_nameservers" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "blog.richtman.com.au"
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
  ttl     = 900
  records = [
    "${aws_route53_zone.richtman_com_au.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

resource "aws_route53_record" "richtman_com_au_MX" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "richtman.com.au."
  type    = "MX"
  ttl     = 3600
  records = [
    "10 mail.protonmail.ch.",
    "20 mailsec.protonmail.ch.",
  ]
}

resource "aws_route53_record" "richtman_com_au_TXT" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "richtman.com.au."
  type    = "TXT"
  ttl     = 3600
  records = [
    "protonmail-verification=e2e0aab73d4d7338f4a9cba4b051a8d2ddfa09ae",
    "v=spf1 include:_spf.protonmail.ch mx ~all",
    "keybase-site-verification=e9jUFGHUN7XqVOGH7CIPMBkk98OXj_egYlj3csYuVJE",
  ]
}

resource "aws_route53_record" "richtman_com_au_dmarc_TXT" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "_dmarc.richtman.com.au."
  type    = "TXT"
  ttl     = 300
  records = [
    "v=DMARC1; p=quarantine",
  ]
}

resource "aws_route53_record" "richtman_com_au_protonmail_domainkey_CNAME" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "protonmail._domainkey.richtman.com.au."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "protonmail.domainkey.d755ltlacr25leectkiqddnrkbzu4o547ig5obzfjrcbe6r3wlu2a.domains.proton.ch.",
  ]
}

resource "aws_route53_record" "richtman_com_au_protonmail2_domainkey_CNAME" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "protonmail2._domainkey.richtman.com.au."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "protonmail2.domainkey.d755ltlacr25leectkiqddnrkbzu4o547ig5obzfjrcbe6r3wlu2a.domains.proton.ch.",
  ]
}

resource "aws_route53_record" "richtman_com_au_protonmail3_domainkey_CNAME" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "protonmail3._domainkey.richtman.com.au."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "protonmail3.domainkey.d755ltlacr25leectkiqddnrkbzu4o547ig5obzfjrcbe6r3wlu2a.domains.proton.ch.",
  ]
}

resource "aws_route53_record" "richtman_com_au_foxops_CNAME" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "foxops.richtman.com.au."
  type    = "CNAME"
  ttl     = 3600
  records = [
    "arichtman.github.io.richtman.com.au",
  ]
}

resource "aws_route53_record" "richtman_com_au_spf_TXT" {
  zone_id = aws_route53_zone.richtman_com_au.zone_id
  name    = "spf.richtman.com.au."
  type    = "TXT"
  ttl     = 3600
  records = [
    "v=spf1 include:_spf.protonmail.ch mx ~all",
  ]
}

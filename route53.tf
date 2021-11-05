#create the route 53 records with a hosted zone already set up for this domain.

data "aws_route53_zone" "domain" {
  name = "sandbox.plastiq.com"
}

resource "aws_route53_record" "subdomain" {
  zone_id = data.aws_route53_zone.domain.id
  name    = "mycoolsite"
  type = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.main.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.main.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.resource_record_type}"
  zone_id = "${data.aws_route53_zone.domain.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.resource_record_value}"]
  ttl     = 60
}
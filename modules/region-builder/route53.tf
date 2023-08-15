# https://registry.terraform.io/providers/-/aws/4.52.0/docs/data-sources/route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record.html


data "aws_route53_zone" "dns_zone" {
  name = var.domain
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = var.domain
  type    = "A"
  set_identifier = "lb-geo-${var.region}"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.region
  }
}
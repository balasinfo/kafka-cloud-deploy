resource "aws_route53_record" "client_public" {
  zone_id = var.route53_zone_public_id
  name    = "es-client.${var.platform_domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.public.dns_name
    zone_id                = data.aws_lb.public.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "master_public" {
  zone_id = var.route53_zone_public_id
  name    = "es-master.${var.platform_domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.public.dns_name
    zone_id                = data.aws_lb.public.zone_id
    evaluate_target_health = false
  }
}

//resource "aws_route53_record" "bastion_public" {
//  zone_id = var.route53_zone_public_id
//  name    = "bastion.${var.platform_domain}"
//  type    = "A"
//  ttl     = "30"
//  records = [var.bastion_ip]
//}



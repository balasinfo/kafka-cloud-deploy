//resource "aws_route53_record" "platform_webapp_stage" {
//  zone_id = var.route53_zone_public_id
//  name    = var.platform_webapp_stage_dns_name
//  type    = "A"
//
//  alias {
//    name                   = data.aws_lb.platform_webapp_stage.dns_name
//    zone_id                = data.aws_lb.platform_webapp_stage.zone_id
//    evaluate_target_health = false
//  }
//}
//
//resource "aws_route53_record" "platform_webapp_prod" {
//  zone_id = var.route53_zone_public_id
//  name    = var.platform_webapp_prod_dns_name
//  type    = "A"
//
//  alias {
//    name                   = data.aws_lb.platform_webapp_prod.dns_name
//    zone_id                = data.aws_lb.platform_webapp_prod.zone_id
//    evaluate_target_health = false
//  }
//}
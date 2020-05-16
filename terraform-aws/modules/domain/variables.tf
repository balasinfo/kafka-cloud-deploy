variable "region" {
  description = "The region to deploy the cluster in, e.g: eu-west-1."
}

variable "profile" {
  description = "The .aws credentials profile to use to connect to AWS"
}

//variable "platform_name" {
//}

//variable "bastion_ip" {
//}

variable "route53_zone_public_id" {
}

variable "platform_domain" {
}

//variable "platform_domain_administrator_email" {
//}

variable "public_lb_arn" {
}

#variable "master_public_dns_name" {
#}
#
#variable "master_public_lb_arn" {
#}

//variable "platform_webapp_stage_dns_name" {
//}
//
//variable "platform_webapp_stage_lb_arn" {
//}
//
//variable "platform_webapp_prod_dns_name" {
//}
//
//variable "platform_webapp_prod_lb_arn" {
//}

//variable "acme_server_env" {
//  default = "staging"
//}


//#provider "aws" {
//#  alias = "ireland"
//#  region = "eu-west-1"
//#}
//#
//#data "aws_acm_certificate" "service_internet_facing" {
//#  domain      = "*.${var.platform_domain}."
//#  types       = ["AMAZON_ISSUED"]
//#  most_recent = true
//#}
//
//locals {
//  server_url = var.acme_server_env == "staging" ? "https://acme-staging-v02.api.letsencrypt.org/directory" : "https://acme-v02.api.letsencrypt.org/directory"
//}
//
//provider "acme" {
//  server_url = local.server_url
//#  server_url = "https://acme-staging.api.letsencrypt.org/directory"
//#  server_url = "https://acme-v02.api.letsencrypt.org/directory"
//}
//
//resource "tls_private_key" "platform_domain_administrator" {
//  algorithm = "RSA"
//}
//
//resource "acme_registration" "platform_domain_administrator" {
//  account_key_pem = tls_private_key.platform_domain_administrator.private_key_pem
//  email_address   = var.platform_domain_administrator_email
//}
//
//resource "tls_private_key" "platform_domain_csr" {
//  algorithm = "RSA"
//}
//
//resource "tls_cert_request" "platform_domain" {
//  key_algorithm   = "RSA"
//  private_key_pem = tls_private_key.platform_domain_csr.private_key_pem
//
//  dns_names = [var.platform_domain]
//
//  subject {
//    common_name = "*.${var.platform_domain}"
//  }
//}
//
//resource "acme_certificate" "platform_domain" {
//  account_key_pem         = acme_registration.platform_domain_administrator.account_key_pem
//  certificate_request_pem = tls_cert_request.platform_domain.cert_request_pem
//
//  dns_challenge {
//    provider = "route53"
//  }
//}
//
//
//# aws_acm_certificate does not work at the moment so we use this implementation
//# https://opencredo.com/blogs/letsencrypt-terraform/
//resource "aws_iam_server_certificate" "alb_cert" {
//  name              = var.platform_domain
//  certificate_body  = element(concat(acme_certificate.platform_domain.*.certificate_pem, list("")), 0)
//  certificate_chain = element(concat(acme_certificate.platform_domain.*.issuer_pem, list("")), 0)
//  private_key       = element(concat(tls_private_key.platform_domain_csr.*.private_key_pem, list("")), 0)
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
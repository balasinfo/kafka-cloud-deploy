// output "public_certificate_pem" {
//   value = element(concat(acme_certificate.platform_domain.*.certificate_pem, list("")), 0)
// }
//
// output "public_certificate_key" {
//   value = element(concat(tls_private_key.platform_domain_csr.*.private_key_pem, list("")), 0)
// }
//
// output "public_certificate_intermediate_pem" {
//   value = element(concat(acme_certificate.platform_domain.*.issuer_pem, list("")), 0)
// }

output "public_zone_id" {
  value = data.aws_route53_zone.public.zone_id
}

//output "bastion_public_dns" {
// value = aws_route53_record.bastion_public.name
//}
//
//output "alb_cert" {
// value = aws_iam_server_certificate.alb_cert.arn
//}

# output "aws_acm_certificate_arn" {
#   value = data.aws_acm_certificate.service_internet_facing.arn
# }

#output "aws_acm_certificate_arn" {
#  value = data.aws_acm_certificate.service_internet_facing.arn
#}


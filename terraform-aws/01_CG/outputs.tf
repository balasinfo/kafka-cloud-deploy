output "key_name" {
  value = module.ssh_key_pair.key_name
  description = "Name of SSH key"
}

output "private_key_filename" {
  description = "Private Key Filename"
  value       = module.ssh_key_pair.private_key_filename
}

output "bastion_ssh_spec" {
  value       = "${module.bastion_server.ssh_user}@${module.bastion_server.public_ip}"
  description = "Bastion SSH info for login. 'ssh `terraform output bastion_ssh`'"
}

output "zk_connect" {
  value = module.kafka.zk_connect
  description = "ZooKeeper private ip's that are used to connect to"
}

output "kafka_bootstrap_server_endpoint" {
  value = module.kafka_route53_cluster_hostname.hostname
  description = "Route 53 endpoint to connect to kafka brokers outside of VPC"
}

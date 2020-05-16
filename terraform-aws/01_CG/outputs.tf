output "key_name" {
  value = module.ssh_key_pair.key_name
  description = "Name of SSH key"
}

#output "public_key" {
#  value = module.ssh_key_pair.public_key
#  description = "Content of the generated public key"
#}
#
#output "private_key" {
#  sensitive = true
#  value = module.ssh_key_pair.private_key
#  description = "Content of the generated private key"
#}
#
#output "public_key_filename" {
#  description = "Public Key Filename"
#  value       = module.ssh_key_pair.public_key_filename
#}

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

/*
 * Kafka test
 *
 * To run the test do the following:
 *   1. create a terraform.tfvars from the example file;
 *   2. terraform init;
 *   3. terraform apply -target module.network; and
 *   4. terraform apply.
 */

provider "aws" {
  region = var.region
  profile = var.user_secret_profile
}

#resource "aws_eip" "public-ips" {
#  count = length(var.availability_zones)
#  vpc = true
#}

resource "aws_eip" "nat_eips" {
  count = 1
  vpc = true
}

resource "aws_eip" "bastion_eips" {
  count = 1
  vpc = true
}

module "network" {
  source = "git::https://github.com/ronaldkonjer/terraform-network.git"
#  region = "eu-west-2"
#  user_secret_profile = "default"
  name = "sol_kafka"
  ssh_access = ["0.0.0.0/0"]
  web_access = ["0.0.0.0/0"]
  availability_zones = var.availability_zones
  bastion_ami = var.ami
  bastion_user = var.user
  private_key_path = var.private_key_path
  key_name = var.key_name
  authorized_keys_path = var.authorized_key_path
  bastion_eip_ids = flatten(aws_eip.bastion_eips.*.id)
  dns_domain = var.domain
  nat_eip_ids = flatten(aws_eip.nat_eips.*.id)
  vpc_cidr = var.cidr_vpc
  public_cidr_prefix = var.public_cidr_prefix
  private_cidr_prefix = var.private_cidr_prefix
}

module "kafka_volumes" {
  source = "git::https://github.com/ronaldkonjer/terraform-ebs-volume.git"
  volumes_per_az = var.brokers_per_az
  app = "kafka"
  name = "infra"
  availability_zones = var.availability_zones
  type = "sc1"
  size = 500
}

module "kafka" {
  source = "./.."
  environment = var.environment
  app_name = "infra"
  ebs_volume_ids = flatten(module.kafka_volumes.volume_ids)
  subnet_ids = module.network.private_subnet_ids
  static_subnet_ids = module.network.private_subnet_ids
  security_group_ids = [module.network.internal_security_group_id]
  iam_instance_profile = var.iam_instance_profile
  key_name = var.key_name
  zookeeper_ami = var.ami
  zookeeper_user = var.user
  zookeeper_instance_type = var.zookeeper_instance_type
  zookeeper_addr = var.zookeeper_addr
  brokers_per_az = var.brokers_per_az
  kafka_ami = var.ami
  kafka_user = var.user
  kafka_instance_type = var.kafka_instance_type
  num_partitions = var.num_partitions
  bastion_ip = length(module.network.bastion_ips) > 0 ? element(module.network.bastion_ips, 0) : ""
  bastion_user = var.user
  private_key = var.private_key_path
  bastion_private_key = length(var.bastion_private_key_path) > 0 ? var.bastion_private_key_path : var.private_key_path
  cloudwatch_alarm_arn = var.cloudwatch_alarm_arn
}

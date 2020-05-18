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
  region  = var.aws_region
  profile = var.user_secret_profile
}

##############################################################################
# LABEL MANAGEMENT
##############################################################################

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.cluster_name
  namespace  = var.namespace
  stage      = var.environment
  tags       = var.tags
  delimiter  = "-"
  attributes = []
  enabled    = true

  label_order = ["name", "stage"]
}

##############################################################################
# REMOTE STATE
##############################################################################
module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=tags/0.9.0"
  namespace             = var.namespace
  stage                 = var.environment
  name                  = var.cluster_name
  ssh_public_key_path   = "${path.module}/.ssh"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

##############################################################################
# REMOTE STATE
##############################################################################

module "remote-state" {
  source                     = "../modules/remote-state"
  region                     = var.aws_region
  profile                    = var.user_secret_profile
  project                    = var.cluster_name
  environment                = var.environment
  name                       = var.cluster_name
  namespace                  = var.namespace
  stage                      = var.environment
  tags                       = var.tags
  create_dynamodb_lock_table = "true"
  create_s3_bucket           = "true"

  shared_aws_account_ids = var.shared_aws_account_ids
  # iam
}

#resource "aws_eip" "public-ips" {
#  count = length(var.availability_zones)
#  vpc = true
#}

#resource "aws_eip" "nat_eips" {
#  count = 1
#  vpc = true
#}
#
#resource "aws_eip" "bastion_eips" {
#  count = 1
#  vpc = true
#}

#module "network" {
#  source = "git::https://github.com/ronaldkonjer/terraform-network.git"
##  region = "eu-west-2"
##  user_secret_profile = "default"
#  name = "sol_kafka"
#  ssh_access = ["0.0.0.0/0"]
#  web_access = ["0.0.0.0/0"]
#  availability_zones = var.availability_zones
#  bastion_ami = var.ami
#  bastion_user = var.user
#  private_key_path = var.private_key_path
#  key_name = var.key_name
#  authorized_keys_path = var.authorized_key_path
# # bastion_eip_ids = flatten(aws_eip.bastion_eips.*.id)
#  dns_domain = var.domain
#  nat_eip_ids = flatten(aws_eip.nat_eips.*.id)
#  vpc_cidr = var.cidr_vpc
#  public_cidr_prefix = var.public_cidr_prefix
#  private_cidr_prefix = var.private_cidr_prefix
#}
#
#############################################################################
# EBS VOLUMES
##############################################################################
module "kafka_volumes" {
  source             = "git::https://github.com/ronaldkonjer/terraform-ebs-volume.git"
  volumes_per_az     = var.brokers_per_az
  availability_zones = var.availability_zones
  type               = "sc1"
  size               = 500
  environment        = var.environment
  name               = var.cluster_name
  namespace          = var.namespace
  tags               = var.tags
}

#############################################################################
# Bastion server
##############################################################################
module "bastion_server" {
  source                       = "git::https://github.com/ronaldkonjer/terraform-aws-ec2-bastion-server.git?ref=feature/0.12upgrade"
  allowed_cidr_blocks          = ["0.0.0.0/0"]
  ami                          = data.aws_ami.debian_image_latest.image_id
  instance_type                = "t2.micro"
  key_name                     = module.ssh_key_pair.key_name
  name                         = "${var.cluster_name}-bastion"
  security_groups              = var.additional_security_groups
  ssh_user                     = var.user
  stage                        = var.environment
  subnets                      = var.public_subnet_ids
  vpc_id                       = var.vpc_id
  zone_id                      = var.route53_zone_public_id
  namespace                    = var.namespace
  tags                         = var.tags
  enable_proxyless             = var.enable_proxyless_ssh
  bastion_private_key_filename = module.ssh_key_pair.private_key_filename
}


##############################################################################
# KAFKA AND ZOOKEEPER
##############################################################################
module "kafka" {
  source                  = "./.."
  environment             = var.environment
  cluster_name                = var.cluster_name
  ebs_volume_ids          = flatten(module.kafka_volumes.volume_ids)
  subnet_ids              = var.private_subnet_ids
  static_subnet_ids       = var.private_subnet_ids
  security_group_ids      = flatten([concat(
  [module.bastion_server.security_group_id],
  var.additional_security_groups,
  )])
  key_name                = module.ssh_key_pair.key_name
  zookeeper_ami           = data.aws_ami.kafka-zookeeper.image_id
  zookeeper_user          = var.user
  zookeeper_instance_type = var.zookeeper_instance_type
  zookeeper_addr          = var.zookeeper_addr
  brokers_per_az          = var.brokers_per_az
  kafka_ami               = data.aws_ami.kafka-zookeeper.image_id
  kafka_user              = var.user
  kafka_instance_type     = var.kafka_instance_type
  num_partitions          = var.num_partitions
  bastion_ip              = module.bastion_server.public_ip
  bastion_user            = module.bastion_server.ssh_user
  private_key             = module.ssh_key_pair.private_key_filename
  bastion_private_key     = module.ssh_key_pair.private_key_filename
  cloudwatch_alarm_arn    = var.cloudwatch_alarm_arn
  iam_instance_profile    = ""
}

module "kafka_elb_http" {
  source          = "terraform-aws-modules/elb/aws"
  version         = "~> 2.0"
  name            = "kafka-elb-http"
  subnets         = local.subnet_ids_public_list
  security_groups = var.additional_security_groups
  internal        = false

  listener = [
    {
      instance_port     = "9092"
      instance_protocol = "TCP"
      lb_port           = "9092"
      lb_protocol       = "TCP"
    }
    #    {
    #      instance_port     = "8080"
    #      instance_protocol = "http"
    #      lb_port           = "8080"
    #      lb_protocol       = "http"
    #      ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    #    },
  ]

  health_check = {
    target              = "TCP:9092"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  access_logs = {
    bucket = "cg-kafka-broker-logs-bucket"
  }

  // ELB attachments
  number_of_instances = length(module.kafka.kafka_servers)
  instances           = module.kafka.kafka_servers

  tags = {
    Name = "${module.label.id}-elb"
  }
}
#
#module kafka_alb {
#  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.9.0"
#  vpc_id                                  = data.aws_vpc.selected.id
#  name                                    = "${var.cluster_name}-alb"
#  namespace                               = var.namespace
#  access_logs_enabled                     = true
#  access_logs_prefix                      = "kafka-broker-"
#  access_logs_region                      = var.aws_region
#  alb_access_logs_s3_bucket_force_destroy = true
#  attributes                              = var.attributes
#  cross_zone_load_balancing_enabled       = true
#  deletion_protection_enabled             = false
#  delimiter                               = var.delimiter
#  deregistration_delay                    = 15
#  health_check_path                       = "/"
#  health_check_timeout                    = 10
#  health_check_healthy_threshold          = 2
#  health_check_unhealthy_threshold        = 2
#  health_check_interval                   = 15
#  health_check_matcher                    = "200-399"
#  http2_enabled                           = true
#  http_enabled                            = true
#  http_redirect                           = false
#  http_port                               = 80
#  internal                                = false
#  security_group_ids                      = var.additional_security_groups
#  stage                                   = var.environment
#  subnet_ids                              = local.subnet_ids_public_list
#  tags                                    = var.tags
#  target_group_port                       = 9092
#  target_group_target_type                = "instance"
#}

module kafka_route53_cluster_hostname {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.3.0"
  enabled = true
  name    = "broker.${var.domain}"
  zone_id = var.route53_zone_public_id
  records = [module.kafka_elb_http.this_elb_dns_name]
}

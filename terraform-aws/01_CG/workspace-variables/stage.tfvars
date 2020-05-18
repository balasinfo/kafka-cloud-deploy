##############################################################################
# AWS config
##############################################################################
aws_region          = "eu-west-1"
user_secret_profile = "cg-iac"

##############################################################################
# Project generic settings
##############################################################################
cluster_name = "kafka"
environment  = "stage"

##############################################################################
# VPC config
##############################################################################
vpc_id             = "vpc-4fac482b"
#cidr_vpc           = "172.24.0.0/16"
availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
public_subnet_ids  = ["subnet-03757d0625a99888a", "subnet-0bb23ce239538fa92", "subnet-0ba8130fd0f50889d"]
private_subnet_ids = ["subnet-3c69ca58", "subnet-0df5207b", "subnet-523cdc0a"]

# the ability to add additional existing security groups. In our case
# traffic from office and CG-DC only
additional_security_groups = ["sg-dd25cdba", "sg-3db3a65a"]
shared_aws_account_ids     = ["807891339983"]

domain                       = "kafka.cgcloud.eu"
route53_zone_public_id       = "Z2CP8DRLO76FWF"

#lb_port = 80
#health_check_type = "EC2"

##############################################################################
# Project specific settings
##############################################################################
#ami                      = "ami-00e8b55a2e841be44"
base_image_filter        = "debian-stretch-*"
kafka_image_filter       = "kafka-2.5.0*"
user                     = "admin"
iam_instance_profile     = ""
#private_key_path         = "~/.ssh/sol_kafka.pem"
#bastion_private_key_path = ""
#authorized_key_path      = "~/.ssh/sol_kafka.pub"
#zookeeper_instance_type  = "t2.medium"
zookeeper_instance_type  = "t2.small"
zookeeper_addr           = 16
#kafka_instance_type      = "m4.large"
kafka_instance_type      = "t2.small"
brokers_per_az           = 1
num_partitions           = 10
cloudwatch_alarm_arn     = "arn:aws:sns:eu-west-1:807891339983:kafkaTestTopic"
enable_proxyless_ssh     = true
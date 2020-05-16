/*
 * Kafka module variables
 */

variable "environment" {
  type = string
  description = "environment to configure"
}

variable "app_name" {
  description = "application name"
  default = "infra"
}

variable "brokers_per_az" {
  description = "number of Kafka brokers per AZ"
  default = 1
}

variable "zookeeper_addr" {
  type = string
  description = "network number for zookeeper IPs"
}

variable "zookeeper_ami" {
  type = string
  description = "AWS AMI for zookeeper"
}

variable "zookeeper_user" {
  type = string
  description = "user in zookeeper AMI"
}

variable "zookeeper_instance_type" {
  type = string
  description = "instance type for zookeeper server"
}

variable "zookeeper_version" {
  description = "Zookeeper version"
  default = "3.6.1"
}

variable "zookeeper_repo" {
  description = "Zookeeper distro site"
  default = "https://downloads.apache.org/zookeeper"
}

variable "kafka_ami" {
  type = string
  description = "AWS AMI for kafka"
}

variable "kafka_user" {
  type = string
  description = "user in kafka AMI"
}

variable "kafka_instance_type" {
  type = string
  description = "instance type for kafka server"
}

variable "kafka_version" {
  description = "Kafka version"
  default = "2.5.0"
}

variable "scala_version" {
  description = "Scala version used in Kafka package"
  default = "2.13"
}

variable "kafka_repo" {
  description = "Kafka distro site"
  default = "http://downloads.apache.org/kafka"
}

variable "ebs_mount_point" {
  description = "mount point for EBS volume"
  default = "/mnt/kafka"
}

variable "ebs_device_name" {
  description = "EBS attached device"
  default = "/dev/xvdf"
}

variable "ebs_volume_ids" {
  type = list(string)
  description = "list of EBS volume IDs"
}

variable "num_partitions" {
  description = "number of partitions per topic"
  default = 1
}

variable "log_retention" {
  description = "retention period (hours)"
  default = 168
}

variable "subnet_ids" {
  type = list(string)
  description = "list of subnet IDs"
}

variable "static_subnet_ids" {
  type = list(string)
  description = "list of subnet IDs for static IPs (/24 CIDR)"
}

variable "security_group_ids" {
  type = list(string)
  description = "list of security group IDs"
}

variable "iam_instance_profile" {
  type = string
  description = "IAM instance profile"
}

variable "key_name" {
  type = string
  description = "key pair for SSH access"
}

variable "private_key" {
  type = string
  description = "local path to ssh private key"
}

variable "bastion_ip" {
  type = string
  description = "bastion IP address for ssh access"
}

variable "bastion_user" {
  type = string
  description = "user on bastion server"
}

variable "bastion_private_key" {
  type = string
  description = "local path to ssh private key for bastion access"
}

variable "cloudwatch_alarm_arn" {
  type = string
  description = "cloudwatch alarm ARN"
}

variable "kafka_broker_alb_arn" {
  type = string
  description = "if set we add the kafka-server instances to the alb target group"
  default = ""
}

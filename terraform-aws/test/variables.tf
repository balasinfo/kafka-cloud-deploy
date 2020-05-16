/*
 * Kafka test variables
 */

variable "region" {
  type = string
}

variable "user_secret_profile" {
  description = "The .aws credentials profile to use to connect to AWS"
}

variable "environment" {
  type = string
}

variable "ami" {
  type = string
}

variable "user" {
  type = string
}

variable "key_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "cidr_vpc" {
  type = string
}

variable "allowed_ingress_list" {
  type = list(string)
}

variable "authorized_key_path" {
  type = string
}

variable "zookeeper_instance_type" {
  type = string
}

variable "zookeeper_addr" {
  type = string
}

variable "brokers_per_az" {
  type = string
}

variable "num_partitions" {
  type = string
}

variable "kafka_instance_type" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "bastion_private_key_path" {
  type = string
}

variable "cloudwatch_alarm_arn" {
  type = string
}

variable "public_cidr_prefix" {
  type        = string
  description = "CIDR prefix (number of bits in mask) for public subnets (-1 indicates use the max subnet size)"
}

variable "private_cidr_prefix" {
  description = "CIDR prefix (number of bits in mask) for private subnets (-1 indicates use the max subnet size)"
  default     = -1
}

variable "domain" {
  type = string
}


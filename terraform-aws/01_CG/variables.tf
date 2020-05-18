/*
 * Kafka CG stage variables
 */


variable "aws_region" {
  type = string
}

variable "user_secret_profile" {
  type        = string
  description = "The .aws credentials profile to use to connect to AWS"
}

variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}


#variable "ami" {
#  type = string
#}

variable "user" {
  type = string
}


variable "availability_zones" {
  type = list(string)
}

#variable "cidr_vpc" {
#  type = string
#}

#variable "allowed_ingress_list" {
#  type = list(string)
#}

#variable "authorized_key_path" {
#  type = string
#}

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

#variable "private_key_path" {
#  type = string
#}

#variable "bastion_private_key_path" {
#  type = string
#}

variable "cloudwatch_alarm_arn" {
  type = string
}

#variable "public_cidr_prefix" {
#  type        = string
#  description = "CIDR prefix (number of bits in mask) for public subnets (-1 indicates use the max subnet size)"
#}

#variable "private_cidr_prefix" {
#  description = "CIDR prefix (number of bits in mask) for private subnets (-1 indicates use the max subnet size)"
#  default     = -1
#}

#variable "domain" {
#  type = string
#}
variable "public_subnet_ids" {
  description = "Public subnet id's that contains load balancers and other publicly accessable instances e.g. bastion hosts. Only one subnet per availability zone allowed."
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Private subnets that contains the kafka and zookeeper applications. Only one subnet per availability zone allowed. "
  type        = list(string)
  default     = []
}

# the ability to add additional existing security groups. In our case
# we have consul running as agents on the box
variable "additional_security_groups" {
  type    = list(string)
  default = []
}


variable "vpc_id" {
  description = "VPC ID to create the Kafka cluster in"
  type        = string
}

variable "route53_zone_public_id" {
  default = ""
}

variable "domain" {
  description = "Public DNS subdomain for access to services served in the cluster"
  default     = ""
}


#### labels

variable "s3_backup_bucket" {
  description = "S3 bucket for backups"
  default     = ""
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, (e.g. `eg` or `cp`)"
  default     = "cg"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "shared_aws_account_ids" {
  description = "A list of AWS account IDs to share the S3 bucket and DynamoDB table with."
  type        = list(string)
  #default     = []
}

variable "base_image_filter" {
  type        = string
  description = "Search string for instance's image"
}

variable "kafka_image_filter" {
  type        = string
  description = "Search string for packer prepared instance's image"
}

variable "enable_proxyless_ssh" {
  type        = bool
  description = "If true we upload the private_key to the bastion so we can ssh into the bastion and continue from there without proxy ssh request from localhost"
  default     = false
}

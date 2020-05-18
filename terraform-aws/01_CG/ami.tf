data "aws_ami" "debian_image_latest" {
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = [var.base_image_filter]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners      = ["379101102735"]
  most_recent = true
}

// Find the latest available AMI for Elasticsearch
data "aws_ami" "kafka-zookeeper" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = [var.kafka_image_filter]
  }
  most_recent = true
  owners      = ["self"]
}
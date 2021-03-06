/*
 * Kafka instances
 */

resource "aws_instance" "zookeeper-server" {
  count                  = local.zk_count
  ami                    = var.zookeeper_ami
  instance_type          = var.zookeeper_instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.static_subnet_ids[count.index]
  private_ip             = cidrhost(element(data.aws_subnet.static-subnet.*.cidr_block, count.index), var.zookeeper_addr)
  iam_instance_profile   = aws_iam_instance_profile.kafka.id
  key_name               = var.key_name
  user_data              = element(data.template_file.zookeeper-init.*.rendered, count.index)
  tags                   = {
    Name = "${var.environment}-${var.cluster_name}-zk-${format("%02d", count.index+1)}"
  }
  #  lifecycle {
  #    create_before_destroy = true
  #  }
}

resource "aws_instance" "kafka-server" {
  count                  = var.brokers_per_az * local.subnet_count
  ami                    = var.kafka_ami
  instance_type          = var.kafka_instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_ids[count.index % length(data.aws_subnet.subnet)]
  iam_instance_profile   = aws_iam_instance_profile.kafka.id
  key_name               = var.key_name
  user_data              = element(data.template_file.kafka-init.*.rendered, count.index)
  tags                   = {
    Name = "${var.environment}-${var.cluster_name}-broker-${format("%02d", count.index+1)}"
  }
}

#resource "aws_alb_target_group_attachment" "kafka-server" {
#  count = length(aws_instance.kafka-server)
#  target_group_arn = var.kafka_broker_alb_arn
#  target_id = element(aws_instance.kafka-server.*.id, count.index)
#}

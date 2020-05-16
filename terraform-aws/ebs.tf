/*
 * Kafka EBS configuration
 */

resource "aws_volume_attachment" "attach" {
  count = length(aws_instance.kafka-server)
  device_name = var.ebs_device_name
  volume_id = element(var.ebs_volume_ids, count.index)
  instance_id = element(aws_instance.kafka-server.*.id, count.index)
  force_detach = true
}

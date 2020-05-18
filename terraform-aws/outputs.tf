/*
 * Kafka module outputs
 */

output "kafka_servers" {
  value = aws_instance.kafka-server.*.id
}

output "zookeeper_servers" {
  value = aws_instance.kafka-server.*.id
}

output "zk_connect" {
  value = join(",", formatlist("%s:2181", aws_instance.zookeeper-server.*.private_ip))
}

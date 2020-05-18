locals {
  static_subnet_count = length(data.aws_subnet.static-subnet)
  subnet_count = length(data.aws_subnet.subnet)
  zk_count = local.static_subnet_count
  kafka_count = var.brokers_per_az * local.subnet_count
}
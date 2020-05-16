locals {
  static_subnet_count = length(data.aws_subnet.static-subnet)
  subnet_count = length(data.aws_subnet.subnet)
}
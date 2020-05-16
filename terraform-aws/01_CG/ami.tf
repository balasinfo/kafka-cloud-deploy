data "aws_ami" "image_latest" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = [var.image_filter]
  }
}
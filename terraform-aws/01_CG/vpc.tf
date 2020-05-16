/*
* Provides data from the selected existing vpc
*/

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "selected" {
  vpc_id = var.vpc_id
}

data "aws_subnet_ids" "selected_private" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "*front-private*"
  }
}

data "aws_subnet_ids" "selected_public" {
  vpc_id = var.vpc_id
  tags   = {
    Name = "*front-public*"
  }
}

locals {
  subnet_ids_string = join(",", data.aws_subnet_ids.selected.ids)
  subnet_ids_list   = split(",", local.subnet_ids_string)

  subnet_ids_private_string = join(",", data.aws_subnet_ids.selected_private.ids)
  subnet_ids_private_list   = split(",", local.subnet_ids_private_string)

  subnet_ids_public_string = join(",", data.aws_subnet_ids.selected_public.ids)
  subnet_ids_public_list   = split(",", local.subnet_ids_public_string)
}

//subnet_id = element(
//coalescelist(var.cluster_subnet_ids, local.subnet_ids_list),
//0,
//)

#vpc_zone_identifier = flatten([coalescelist(var.cluster_subnet_ids, local.subnet_ids_list)])

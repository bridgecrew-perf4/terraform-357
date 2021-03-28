data "aws_availability_zones" "zones" {
  state = "available"
} 

locals {
  availability_zone = data.aws_availability_zones.zones.names
}

module "dev" {
  source = "../../module/vpc/"
  
  region = "${var.region}"
  environment = "${var.environment}"
  vpc_cidr = "${var.vpc_cidr}"
  public_subnet_cidr = "${var.public_subnet_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
  availability_zone = "${local.availability_zone}"
}
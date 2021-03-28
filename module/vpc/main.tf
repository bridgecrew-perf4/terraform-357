resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.environment}_vpc"
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "eip_nat_private" {
  depends_on = [aws_internet_gateway.igw_public]

  vpc = true
}

resource "aws_nat_gateway" "nat_private" {
  depends_on = [aws_internet_gateway.igw_public]
  allocation_id = "${aws_eip.eip_nat_private.id}"
  subnet_id = "${element(aws_subnet.subnet_public.*.id, 0)}"
  
  tags = {
    Name = "nat_private"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "igw_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  
  tags = {
    Name = "${var.environment}_igw_public"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.environment}_route_table_private"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.environment}_route_table_public"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "internet_gateway_public" {
  route_table_id = "${aws_route_table.public.id}"
  gateway_id = "${aws_internet_gateway.igw_public.id}"

  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "internet_gateway_private" {
  route_table_id = "${aws_route_table.private.id}"
  nat_gateway_id = "${aws_nat_gateway.nat_private.id}"

  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(var.public_subnet_cidr)}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-subnet-public-${element(var.availability_zone, count.index)}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(var.private_subnet_cidr)}"
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zone, count.index)}"

  tags = {
    Name = "${var.environment}-subnet-private-${element(var.availability_zone, count.index)}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "route_private" {
  count = "${length(aws_subnet.subnet_private)}"

  subnet_id = "${element(aws_subnet.subnet_private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "route_public" {
  count = "${length(aws_subnet.subnet_public)}"

  subnet_id = "${element(aws_subnet.subnet_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_security_group" "sg_vpc" {
  depends_on = [aws_vpc.vpc]
  vpc_id = "${aws_vpc.vpc.id}"

  name = "${var.environment}_vpc_sg"
  description = "Default security group to allow inbound/outbound from the VPC"

  tags = {
    Name = "${var.environment}_vpc_sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "outbound-all" {
  security_group_id =  aws_security_group.sg_vpc.id

  type = "egress"
  to_port = "0"
  from_port = "0"
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound-http" {
  security_group_id =  aws_security_group.sg_vpc.id

  type = "ingress"
  to_port = "80"
  from_port = "80"
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound-https" {
  security_group_id =  aws_security_group.sg_vpc.id

  type = "ingress"
  to_port = "443"
  from_port = "443"
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
}
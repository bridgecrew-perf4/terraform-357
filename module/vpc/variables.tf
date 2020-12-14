variable "environment" {
    description = "infrastructure environment"
}

variable "region" {
    description = "infrastructure region"
}

variable "vpc_cidr" {
    description = "vpc cidr block"
}

variable "public_subnet_cidr" {
  type        = list
  description = "public subnet cidr block"
}

variable "private_subnet_cidr" {
  type        = list
  description = "private subnet cidr block"
}

variable "availability_zone" {
  type        = list
  description = "availability zones"
}
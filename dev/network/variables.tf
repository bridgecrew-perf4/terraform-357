variable "environment" {
    description = "application environment"
}

variable "region" {
    description = "application environment"
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
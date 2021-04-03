output "vpc" {
  value = aws_vpc.vpc.id
}

output "subnet_private" {
  value = aws_subnet.subnet_private.*.id
}

output "subnet_public" {
  value = aws_subnet.subnet_public.*.id
}
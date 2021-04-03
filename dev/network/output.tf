output "vpc_id" {
  value = module.dev.vpc
}

output "subnet_private_id" {
  value = module.dev.subnet_private
}

output "subnet_public_id" {
  value = module.dev.subnet_public
}
# modules/vpc/outputs.tf

output "network_name" {
  description = "The name of the VPC network"
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.vpc.subnets_names[0]
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = module.vpc.network_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnets_ids[0]
}
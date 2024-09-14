# modules/vpc/outputs.tf

output "vpc_id" {
  description = "ID of the created VPC"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = google_compute_subnetwork.subnet.id
}
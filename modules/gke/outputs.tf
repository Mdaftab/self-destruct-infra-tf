# modules/gke/outputs.tf

output "cluster_name" {
  description = "The name of the cluster"
  value       = module.gke.name
}

output "cluster_region" {
  description = "The region of the cluster"
  value       = var.region
}

output "project_id" {
  description = "The project ID where the cluster is created"
  value       = var.project_id
}

output "endpoint" {
  description = "The IP address of the cluster master"
  sensitive   = true
  value       = module.gke.endpoint
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  sensitive   = true
  value       = module.gke.ca_certificate
}
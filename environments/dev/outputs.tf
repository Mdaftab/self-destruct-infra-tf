# environments/dev/outputs.tf

output "cluster_name" {
  description = "The name of the cluster"
  value       = module.gke.cluster_name
}

output "cluster_region" {
  description = "The region of the cluster"
  value       = module.gke.cluster_region
}

output "project_id" {
  description = "The project ID where the cluster is created"
  value       = module.gke.project_id
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

output "get_credentials_command" {
  description = "Command to get credentials for the cluster"
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${module.gke.cluster_region} --project ${module.gke.project_id}"
}

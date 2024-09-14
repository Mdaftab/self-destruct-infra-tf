# environments/dev/variables.tf

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone for the GKE cluster"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "pod_cidr" {
  description = "CIDR range for Kubernetes pods"
  type        = string
}

variable "svc_cidr" {
  description = "CIDR range for Kubernetes services"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-micro"
}

variable "preemptible" {
  description = "Use preemptible nodes"
  type        = bool
  default     = true
}

variable "disk_size_gb" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 10
}

variable "environment_ttl" {
  description = "Time to live for the environment (e.g., 72h for 3 days)"
  type        = string
  default     = "72h"
}


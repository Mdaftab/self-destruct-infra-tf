
# modules/gke/variables.tf

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "zone" {
  description = "Zone for the GKE cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
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

variable "env" {
  description = "Environment label for the GKE cluster"
  type        = string
}

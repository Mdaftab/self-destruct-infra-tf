# modules/gke/variables.tf

variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "zone" {
  description = "The zone to host the cluster in"
  type        = string
}

variable "network_name" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnet_name" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the node pool"
  type        = string
  default     = "e2-micro"
}

variable "authorized_ip" {
  description = "The IP address that will be allowed to access the cluster"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation for the master network"
  type        = string
}

variable "cluster_viewers" {
  description = "List of users/SAs that can view the cluster"
  type        = list(string)
  default     = []
}

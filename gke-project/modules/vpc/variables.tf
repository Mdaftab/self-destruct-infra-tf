# modules/vpc/variables.tf

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "region" {
  description = "Region for the subnet"
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


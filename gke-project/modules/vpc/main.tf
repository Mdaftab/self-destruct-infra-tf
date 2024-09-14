# modules/vpc/main.tf

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = "${var.subnet_name}-pod-range"
    ip_cidr_range = var.pod_cidr
  }

  secondary_ip_range {
    range_name    = "${var.subnet_name}-svc-range"
    ip_cidr_range = var.svc_cidr
  }
}


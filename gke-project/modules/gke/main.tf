# modules/gke/main.tf

# Cost-Optimization Features:
# - Uses preemptible nodes (default)
# - Disabled logging and monitoring services
# - Uses e2-micro machine type by default
# - Uses Ubuntu OS for better free tier compatibility

# Security Configuration:
# - Removes default node pool for better security
# - Uses minimal OAuth scopes for node service accounts
# - Configured with separate pod and service CIDR ranges

# Maintenance:
# - Uses REGULAR release channel for automatic updates
# - Deletion protection is disabled for easier cleanup

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_id
  subnetwork = var.subnet_id

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.subnet_name}-pod-range"
    services_secondary_range_name = "${var.subnet_name}-svc-range"
  }

  # Disable some features to reduce costs
  logging_service    = "none"
  monitoring_service = "none"
  
  # Use release channel instead of specific version
  release_channel {
    channel = "REGULAR"
  }
  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]

    labels = {
      env = var.env
    }

    machine_type = var.machine_type
    preemptible  = var.preemptible
    disk_size_gb = var.disk_size_gb

    # Use Ubuntu as the OS image for more free tier compatibility
    image_type = "UBUNTU_CONTAINERD"
  }
}

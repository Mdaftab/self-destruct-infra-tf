# environments/dev/main.tf

# Project Structure:
#
# /environments/
#   - dev/      # Development environment configuration
#   - staging/  # Staging environment configuration
#   - prod/     # Production environment configuration
#
# /modules/
#   - gcp-services/  # Enables required GCP APIs
#   - vpc/          # VPC and networking configuration
#   - gke/          # GKE cluster configuration

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gcp_services" {
  source = "../../modules/gcp-services"
}

module "vpc" {
  source      = "../../modules/vpc"
  vpc_name    = "${var.env}-vpc"
  subnet_name = "${var.env}-subnet"
  subnet_cidr = var.subnet_cidr
  region      = var.region
  pod_cidr    = var.pod_cidr
  svc_cidr    = var.svc_cidr

  depends_on = [module.gcp_services]
}

module "gke" {
  source       = "../../modules/gke"
  cluster_name = "${var.env}-gke-cluster"
  zone         = var.zone
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.subnet_id
  subnet_name  = "${var.env}-subnet"
  node_count   = var.node_count
  machine_type = var.machine_type
  preemptible  = var.preemptible
  disk_size_gb = var.disk_size_gb
  env          = var.env

  depends_on = [module.vpc]
}

# This environment includes a self-destruct mechanism that automatically
# destroys resources after the specified TTL (default: 72h)
# Important: Monitor the environment_ttl variable in variables.tf

# Resource Dependencies:
# 1. GCP Services must be enabled first
# 2. VPC must be created before GKE cluster
# 3. GKE cluster must be created before self-destruct mechanism

# Include the self-destruct mechanism
resource "null_resource" "self_destruct" {
  depends_on = [module.gke]

  triggers = {
    expiration_date = timeadd(timestamp(), var.environment_ttl)
  }

  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > self_destruct.sh
      #!/bin/bash
      EXPIRATION_DATE="${self.triggers.expiration_date}"
      CURRENT_DATE=\$(date -u +"%Y-%m-%dT%H:%M:%SZ")
      if [[ "\$CURRENT_DATE" > "\$EXPIRATION_DATE" ]]; then
        echo "Environment has expired. Initiating self-destruct sequence..."
        terraform destroy -auto-approve
      else
        echo "Environment is still valid. Expiration date: \$EXPIRATION_DATE"
      fi
      EOF
      chmod +x self_destruct.sh
      (crontab -l 2>/dev/null; echo "0 * * * * $(pwd)/self_destruct.sh") | crontab -
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "crontab -r || true"
  }
}

# Self-Destruct Features:
# - Automatically destroys environment after TTL expires
# - Runs hourly check via crontab
# - Removes crontab entry on destroy
# - Uses UTC timestamps for consistency
#
# Warning: Ensure proper permissions for terraform destroy
# command when running in automated mode

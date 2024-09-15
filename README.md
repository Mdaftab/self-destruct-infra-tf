# GKE Test Cluster  Deployment and self-destruct

This project contains Terraform configurations to deploy a minimal Google Kubernetes Engine (GKE) cluster on Google Cloud Platform (GCP). It's designed for testing purposes and is optimized for use with GCP's free tier. 

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Configuration](#configuration)
4. [Deployment](#deployment)
5. [Accessing the Cluster](#accessing-the-cluster)
6. [Self-Destruct Mechanism](#self-destruct-mechanism)
7. [Clean Up](#clean-up)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following:

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured
- [Terraform](https://www.terraform.io/downloads.html) (version 0.12.0 or later) installed
- A Google Cloud Platform account with billing enabled
- A GCP project created
- Owner or Editor role on the GCP project
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed (for accessing the cluster)

## Project Structure

```
gke-project/
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── modules/
│   ├── gke/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── gcp-services/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── .gitignore
└── README.md
```

## Configuration

1. Navigate to the `environments/dev` directory.
2. Open `terraform.tfvars` and update the values according to your requirements:

```hcl
project_id      = "your-project-id"
region          = "us-central1"
zone            = "us-central1-a"
subnet_cidr     = "10.0.0.0/20"
pod_cidr        = "10.1.0.0/16"
svc_cidr        = "10.2.0.0/20"
node_count      = 1
machine_type    = "e2-micro"
preemptible     = true
disk_size_gb    = 10
environment_ttl = "72h"
```

**Note**: The configuration is optimized for GCP's free tier. Adjust carefully to avoid unexpected charges.

## Deployment

1. Set up GCP credentials:
   ```
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Preview the changes:
   ```
   terraform plan
   ```

4. Apply the configuration:
   ```
   terraform apply
   ```

   Type `yes` when prompted to create the resources.

## Accessing the Cluster

After successful deployment, configure `kubectl` to access your cluster:

```
gcloud container clusters get-credentials $(terraform output -raw cluster_name) --zone $(terraform output -raw zone) --project $(terraform output -raw project_id)
```

Verify the connection:

```
kubectl get nodes
```

## Self-Destruct Mechanism

This project includes an automated self-destruct mechanism to ensure that resources are not left running indefinitely, which could lead to unexpected costs. This feature is crucial for maintaining cost-efficiency in test environments.

### How it works:

1. **Trigger**: The mechanism is implemented using a `null_resource` in Terraform, which creates a local script and sets up a cron job.

2. **TTL Configuration**: The lifespan of the environment is controlled by the `environment_ttl` variable in `terraform.tfvars`. By default, it's set to "72h" (3 days).

3. **Cron Job**: A cron job is created on the local machine that runs every hour to check if the environment has exceeded its TTL.

4. **Destruction Process**: If the current time exceeds the expiration time, the script automatically runs `terraform destroy -auto-approve` to remove all created resources.

### Important Notes:

- The self-destruct mechanism relies on the local machine where Terraform was executed. It will not work if this machine is turned off or if the cron job is removed.
- Ensure that the machine running the cron job has the necessary permissions to destroy the GCP resources.
- The `environment_ttl` can be adjusted in `terraform.tfvars` based on your testing needs.
- Always monitor your GCP billing to ensure resources are destroyed as expected.

### Manual Override:

If you need to keep the environment running longer than the specified TTL:

1. SSH into the machine where Terraform was run.
2. Edit the crontab: `crontab -e`
3. Remove or comment out the line containing `self_destruct.sh`
4. Save and exit the crontab editor.

Remember to manually destroy the resources when they're no longer needed:

```
terraform destroy
```

This self-destruct feature adds an extra layer of security against runaway costs, but it should not be the only method relied upon for resource management. Regular monitoring and manual verification are still recommended.

## Clean Up

To manually destroy the resources:

```
terraform destroy
```

Type `yes` when prompted to destroy the resources.

## Best Practices

1. Use version control (e.g., Git) to track changes to your Terraform configurations.
2. Don't commit sensitive information (like service account keys) to version control.
3. Use variables and `terraform.tfvars` for environment-specific configurations.
4. Regularly update your Terraform version and provider versions.
5. Use workspaces if you need to manage multiple environments (e.g., dev, staging, prod).
6. Enable and review GCP audit logs to monitor activities in your project.
7. Regularly verify that the self-destruct mechanism is functioning as expected, especially after any system updates or reboots.
8. Consider implementing additional monitoring or alerts to notify you when resources are about to be or have been destroyed.

## Troubleshooting

1. **API Enabling Failed**: Ensure your GCP account has the necessary permissions and that billing is enabled for the project.

2. **Quota Exceeded**: Check your GCP quotas and request increases if necessary.

3. **Networking Issues**: Verify that the CIDR ranges don't overlap with any existing networks in your GCP project.

4. **Terraform State Corruption**: If you encounter state-related issues, try running `terraform refresh` before other commands.

5. **GKE Version Mismatch**: The project uses the `REGULAR` release channel. If you need a specific version, modify the `google_container_cluster` resource in `modules/gke/main.tf`.

For more detailed errors, run Terraform commands with increased verbosity:

```
TF_LOG=DEBUG terraform apply
```

If you encounter persistent issues, please check the [GCP Status Dashboard](https://status.cloud.google.com/) and the [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) documentation.
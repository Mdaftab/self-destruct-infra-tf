# GKE Test Cluster Deployment

![BUILT BY](https://img.shields.io/badge/BUILT%20BY-DEVOPS%20ENGINEERS-brightgreen?style=for-the-badge&logo=terraform)
![BUILT WITH](https://img.shields.io/badge/BUILT%20WITH-%E2%9D%A4-ff69b4?style=for-the-badge&logo=love)
![BUILT WITH](https://img.shields.io/badge/BUILT%20WITH-TERRAFORM-blueviolet?style=for-the-badge&logo=terraform)
![MADE WITH](https://img.shields.io/badge/MADE%20WITH-GCP-blue?style=for-the-badge&logo=google-cloud)

![Contributors](https://img.shields.io/github/contributors/yourusername/gke-test-cluster-deployment?style=flat-square)
![Issues](https://img.shields.io/github/issues/yourusername/gke-test-cluster-deployment?style=flat-square)
![Pull Requests](https://img.shields.io/github/issues-pr/yourusername/gke-test-cluster-deployment?style=flat-square)
![Forks](https://img.shields.io/github/forks/yourusername/gke-test-cluster-deployment?style=flat-square)
![Stars](https://img.shields.io/github/stars/yourusername/gke-test-cluster-deployment?style=flat-square)
![License](https://img.shields.io/github/license/yourusername/gke-test-cluster-deployment?style=flat-square)

This project contains Terraform configurations to deploy a minimal Google Kubernetes Engine (GKE) cluster on Google Cloud Platform (GCP). It's designed for testing purposes and is optimized for use with GCP's free tier.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Initial Setup](#initial-setup)
4. [Configuration](#configuration)
5. [Deployment](#deployment)
6. [Accessing the Cluster](#accessing-the-cluster)
7. [Self-Destruct Mechanism](#self-destruct-mechanism)
8. [Clean Up](#clean-up)
9. [Best Practices](#best-practices)
10. [Extending the Project](#extending-the-project)
11. [CI/CD and State Management](#cicd-and-state-management)
12. [Troubleshooting](#troubleshooting)

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
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
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
├── scripts/
│   └── makefolder.sh
├── .gitignore
└── README.md
```

## Initial Setup

1. Clone this repository to your local machine.

2. Run the `makefolder.sh` script to create the necessary folder structure:

   ```
   chmod +x scripts/makefolder.sh
   ./scripts/makefolder.sh
   ```

   This script will create the folder structure outlined above.

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

5. **Note on Deletion Protection**: By default, this project sets `deletion_protection = false` for the GKE cluster. This allows for easier destruction of the infrastructure. In production environments, you may want to set this to `true` to prevent accidental deletion.

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

Remember to manually destroy the resources when they're no longer needed.

## Clean Up

To manually destroy the resources:

```
terraform destroy
```

Type `yes` when prompted to destroy the resources.

If you encounter issues destroying the cluster due to deletion protection, ensure that the `deletion_protection = false` line is present in the `google_container_cluster` resource in `modules/gke/main.tf`.

If you've manually enabled deletion protection in the Google Cloud Console, you'll need to disable it there before running `terraform destroy`:

1. Go to the Google Cloud Console
2. Navigate to Kubernetes Engine > Clusters
3. Click on your cluster
4. Click "Edit"
5. Scroll down to "Deletion protection"
6. Uncheck the box for "Deletion protection"
7. Click "Save"

After disabling deletion protection, try running `terraform destroy` again.

## Best Practices

1. Use version control (e.g., Git) to track changes to your Terraform configurations.
2. Don't commit sensitive information (like service account keys) to version control.
3. Use variables and `terraform.tfvars` for environment-specific configurations.
4. Regularly update your Terraform version and provider versions.
5. Use workspaces if you need to manage multiple environments (e.g., dev, staging, prod).
6. Enable and review GCP audit logs to monitor activities in your project.
7. Regularly verify that the self-destruct mechanism is functioning as expected, especially after any system updates or reboots.
8. Consider implementing additional monitoring or alerts to notify you when resources are about to be or have been destroyed.
9. Use a centralized backend for storing Terraform state files, such as Google Cloud Storage, to enable team collaboration and maintain state consistency.
10. Implement a CI/CD pipeline for automated testing and deployment of your infrastructure changes.

## Extending the Project

This project includes configurations for dev, staging, and prod environments. To use or extend these environments:

1. Navigate to the desired environment folder (e.g., `environments/staging/`).
2. Update the `terraform.tfvars` file with appropriate values for that environment.
3. Follow the same deployment steps as outlined for the dev environment.

Remember to adjust resource specifications and security settings appropriately for each environment, especially for production use.

## CI/CD and State Management

### Implementing CI/CD

To implement CI/CD for this project, consider the following steps:

1. Use a version control system like Git to manage your Terraform configurations.
2. Implement a CI/CD pipeline using tools like Jenkins, GitLab CI, or Google Cloud Build.
3. In your pipeline, include steps to:
   - Run `terraform fmt` to ensure consistent formatting
   - Run `terraform validate` to check for configuration errors
   - Run `terraform plan` to preview changes
   - (Optionally) Automatically apply changes for certain environments

### State File Management

For better collaboration and state management:

1. Use a remote backend for storing Terraform state. Google Cloud Storage is a good option for GCP projects. Add a backend configuration to your Terraform files:

   ```hcl
   terraform {
     backend "gcs" {
       bucket  = "your-terraform-state-bucket"
       prefix  = "terraform/state"
     }
   }
   ```

2. Create the GCS bucket before initializing Terraform:

   ```
   gsutil mb gs://your-terraform-state-bucket
   ```

3. Use state locking to prevent concurrent modifications:

   ```hcl
   terraform {
     backend "gcs" {
       bucket  = "your-terraform-state-bucket"
       prefix  = "terraform/state"
       lock_table = "terraform-state-lock"
     }
   }
   ```

   Create a DynamoDB table for state locking (note that this requires setting up additional GCP APIs).

Remember to update your CI/CD pipeline to handle backend initialization and provide necessary credentials for accessing the remote state.

## Troubleshooting

1. **API Enabling Failed**: Ensure your GCP account has the necessary permissions and that billing is enabled for the project.

2. **Quota Exceeded**: Check your GCP quotas and request increases if necessary.

3. **Networking Issues**: Verify that the CIDR ranges don't overlap with any existing networks in your GCP project.

4. **Terraform State Corruption**: If you encounter state-related issues, try running `terraform refresh` before other commands.

5. **GKE Version Mismatch**: The project uses the `REGULAR` release channel. If you need a specific version, modify the `google_container_cluster` resource in `modules/gke/main.tf`.

6. **Unable to Destroy Resources**: If you're unable to destroy resources due to deletion protection, ensure that `deletion_protection = false` is set in the Terraform configuration for the GKE cluster. If you've manually enabled deletion protection in the Google Cloud Console, you'll need to disable it there before running `terraform destroy`.

For more detailed errors, run Terraform commands with increased verbosity:

```
TF_LOG=DEBUG terraform apply
```

If you encounter persistent issues, please check the [GCP Status Dashboard](https://status.cloud.google.com/) and the [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs) documentation.

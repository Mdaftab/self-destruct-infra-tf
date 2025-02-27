# Self-Destructing GKE Infrastructure

A cost-efficient, automated Kubernetes infrastructure deployment on Google Cloud Platform (GCP) using Terraform. This project creates a private GKE cluster optimized for minimal resource consumption and includes self-destruction capabilities.

## 🎯 Features

- **Cost Optimization**
  - Uses e2-micro machine type
  - Leverages spot instances
  - Minimal node count (1-2 nodes)
  - Optimized resource requests

- **Security**
  - Private GKE cluster
  - VPC-native networking
  - Shielded nodes
  - Limited OAuth scopes
  - Minimal service account permissions

- **Infrastructure**
  - Regional cluster with single-zone deployment
  - Custom VPC with dedicated subnets
  - Cloud NAT for internet access
  - Automated node pool management
  - Self-destructing mechanism

- **Self-Destruction**
  - Automated infrastructure teardown
  - Scheduled destruction
  - Manual trigger option

## 📋 Prerequisites

- Terraform >= 1.0
- Google Cloud SDK
- kubectl
- gke-gcloud-auth-plugin

Required GCP APIs:
```bash
compute.googleapis.com
container.googleapis.com
cloudresourcemanager.googleapis.com
iam.googleapis.com
```

## 🚀 Quick Start

1. **Setup GCP Project**
   ```bash
   # Run the bootstrap script to install prerequisites
   ./scripts/bootstrap.sh
   ```

2. **Configure Environment**
   - Copy `environments/dev/terraform.tfvars.example` to `environments/dev/terraform.tfvars`
   - Update the variables with your GCP project details

3. **Deploy Infrastructure**
   ```bash
   cd environments/dev
   terraform init
   terraform plan
   terraform apply
   ```

4. **Connect to Cluster**
   ```bash
   ./scripts/connect.sh
   ```

5. **Deploy Demo Application** (Optional)
   ```bash
   kubectl apply -f kubernetes/manifests/deployment.yaml
   ```

## 🏗️ Project Structure

```
/gke-project
├── environments/dev/          # Environment-specific configurations
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Output definitions
│   └── terraform.tfvars      # Variable values (create from example)
├── modules/                   # Reusable Terraform modules
│   ├── gke/                  # GKE cluster module
│   └── vpc/                  # VPC network module
├── kubernetes/               # Kubernetes resources
│   └── manifests/           # Kubernetes manifest files
│       └── deployment.yaml  # Demo application deployment
├── scripts/                  # Utility scripts
│   ├── bootstrap.sh         # Setup script
│   └── connect.sh           # Cluster connection script
└── README.md
```

## ⚙️ Configuration

### VPC Configuration
- Subnet CIDR: 10.0.0.0/24
- Pod CIDR: 10.1.0.0/16
- Service CIDR: 10.2.0.0/16
- Master CIDR: 172.16.0.0/28

### GKE Configuration
- Machine Type: e2-micro
- Node Pool Size: 1-2 nodes
- Spot Instances: Enabled
- Private Cluster: Enabled
- Regional Deployment: Yes

## 🔐 Security Notes

1. Ensure your `terraform.tfvars` file is never committed to version control
2. Use service accounts with minimal required permissions
3. Regularly rotate service account keys
4. Keep your GKE cluster version updated
5. Monitor cluster logs and metrics

## 🛠️ Maintenance

### Updating the Cluster
```bash
# Get latest changes
git pull

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Destroying the Infrastructure
```bash
terraform destroy
```

## ⚠️ Limitations

- e2-micro instances are extremely resource-constrained
- Limited to lightweight workloads
- Requires manual resource scaling for complex applications
- Spot instances may be terminated with short notice

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions, please open an issue in the repository.

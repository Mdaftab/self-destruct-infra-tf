#!/bin/bash

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run this script with sudo"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install required packages
print_status "Installing required packages..."

# Add Google Cloud SDK repository
if [ ! -f /etc/apt/sources.list.d/google-cloud-sdk.list ]; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
fi

# Add Hashicorp repository
if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
fi

# Update package list
sudo apt-get update

# Install packages
PACKAGES="terraform google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin kubectl"
for package in $PACKAGES; do
    if ! command_exists $package; then
        sudo apt-get install -y $package
        print_status "Installed $package"
    else
        print_warning "$package is already installed"
    fi
done

# Verify installations
print_status "Verifying installations..."
terraform version
gcloud version
kubectl version --client

# Setup project configuration
print_status "Setting up project configuration..."

# Create necessary directories
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Copy example configuration files
if [ ! -f environments/dev/terraform.tfvars ]; then
    cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
    print_status "Created terraform.tfvars from example"
    print_warning "Please edit environments/dev/terraform.tfvars with your project details"
else
    print_warning "terraform.tfvars already exists"
fi

if [ ! -f environments/dev/backend.tf ]; then
    cp environments/dev/backend.tf.example environments/dev/backend.tf
    print_status "Created backend.tf from example"
    print_warning "Please edit environments/dev/backend.tf with your backend configuration"
else
    print_warning "backend.tf already exists"
fi

# Print next steps
cat << EOF

${GREEN}=== Bootstrap Complete ===${NC}

${YELLOW}Next Steps:${NC}
1. Edit your configuration files:
   - ${YELLOW}environments/dev/terraform.tfvars${NC} (Add your project details)
   - ${YELLOW}environments/dev/backend.tf${NC} (Configure state backend)

2. Authenticate with Google Cloud:
   ${GREEN}gcloud auth application-default login${NC}

3. Deploy the infrastructure:
   ${GREEN}cd environments/dev
   terraform init
   terraform plan
   terraform apply${NC}

4. Connect to the cluster:
   ${GREEN}../../scripts/connect.sh${NC}

For more information, see the README.md file.
EOF

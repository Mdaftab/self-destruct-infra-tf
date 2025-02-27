#!/bin/bash

# Exit on error
set -e

echo "Installing prerequisites for GKE cluster deployment..."

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Install Google Cloud SDK
if ! command -v gcloud &> /dev/null; then
    echo "Installing Google Cloud SDK..."
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk
fi

# Install kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    sudo apt-get install -y kubectl
fi

# Install GKE auth plugin
if ! command -v gke-gcloud-auth-plugin &> /dev/null; then
    echo "Installing GKE auth plugin..."
    sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
fi

# Install Terraform
if ! command -v terraform &> /dev/null; then
    echo "Installing Terraform..."
    sudo apt-get install -y software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y terraform
fi

echo "All prerequisites installed successfully!"
echo "Please ensure you have:"
echo "1. Set up a Google Cloud project"
echo "2. Enabled necessary APIs (Container API, Compute Engine API)"
echo "3. Created a service account with appropriate permissions"
echo "4. Downloaded the service account key"
echo "5. Set your project ID in the terraform.tfvars file"

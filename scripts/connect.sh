#!/bin/bash

# Exit on error
set -e

# Change to the dev environment directory
cd "$(dirname "$0")/../environments/dev"

# Get cluster info from Terraform output
CLUSTER_NAME=$(terraform output -raw cluster_name)
CLUSTER_REGION=$(terraform output -raw cluster_region)
PROJECT_ID=$(terraform output -raw project_id)

echo "Connecting to GKE cluster..."
echo "Cluster: $CLUSTER_NAME"
echo "Region: $CLUSTER_REGION"
echo "Project: $PROJECT_ID"

# Configure kubectl
gcloud container clusters get-credentials "$CLUSTER_NAME" \
  --region "$CLUSTER_REGION" \
  --project "$PROJECT_ID"

# Verify connection
echo -e "\nVerifying cluster connection..."
kubectl cluster-info

# Print available nodes
echo -e "\nCluster nodes:"
kubectl get nodes

echo -e "\nConnection successful! 🚀"
echo "You can now use kubectl to interact with your cluster."

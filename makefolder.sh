#!/bin/bash

# Create the main project directory
mkdir -p gke-project

# Create the environments and their subdirectories
for env in dev staging prod; do
    mkdir -p gke-project/environments/$env
    touch gke-project/environments/$env/main.tf
    touch gke-project/environments/$env/variables.tf
    touch gke-project/environments/$env/terraform.tfvars
done

# Create the modules and their subdirectories
for module in gke vpc gcp-services; do
    mkdir -p gke-project/modules/$module
    touch gke-project/modules/$module/main.tf
    touch gke-project/modules/$module/variables.tf
    touch gke-project/modules/$module/outputs.tf
done

# Create .gitignore and README.md in the root directory
touch gke-project/.gitignore
touch gke-project/README.md

echo "Folder hierarchy created successfully!"
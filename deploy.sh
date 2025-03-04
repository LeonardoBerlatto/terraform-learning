#!/bin/bash

# Multi-cloud deployment script
# Usage: ./deploy.sh [aws|gcp|azure|oci|all]

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a command is available
check_command() {
  if ! command -v $1 &> /dev/null; then
    echo -e "${RED}Error: $1 command not found. Please install it first.${NC}"
    exit 1
  fi
}

# Check if terraform is installed
check_command terraform

# Create temporary tfvars file
create_tfvars() {
  cat > temp.tfvars <<EOF
bucket_name = "temp-image-bucket-leonardo-berlatto"
owner       = "LeonardoBerlatto"
environment = "dev"

cloud_providers = {
  aws   = $AWS
  gcp   = $GCP
  azure = $AZURE
  oci   = $OCI
}

# Fill in your cloud provider details below
aws_region = "us-east-2"

# Only needed if GCP is enabled
gcp_project_id = "$GCP_PROJECT_ID"
gcp_region     = "us-central1"

# Only needed if Azure is enabled
azure_location      = "eastus"
azure_resource_group = "storage-rg"

# Only needed if OCI is enabled  
oci_region        = "us-ashburn-1"
oci_compartment_id = "$OCI_COMPARTMENT_ID"
oci_namespace      = "$OCI_NAMESPACE"
EOF
}

# Default values
AWS=false
GCP=false
AZURE=false
OCI=false

# Parse arguments
case "$1" in
  aws)
    echo -e "${BLUE}Deploying to AWS${NC}"
    AWS=true
    ;;
  gcp)
    echo -e "${BLUE}Deploying to Google Cloud Platform${NC}"
    GCP=true
    
    if [ -z "$GCP_PROJECT_ID" ]; then
      read -p "Enter your GCP Project ID: " GCP_PROJECT_ID
    fi
    ;;
  azure)
    echo -e "${BLUE}Deploying to Microsoft Azure${NC}"
    AZURE=true
    ;;
  oci)
    echo -e "${BLUE}Deploying to Oracle Cloud Infrastructure${NC}"
    OCI=true
    
    if [ -z "$OCI_COMPARTMENT_ID" ]; then
      read -p "Enter your OCI Compartment ID: " OCI_COMPARTMENT_ID
    fi
    
    if [ -z "$OCI_NAMESPACE" ]; then
      read -p "Enter your OCI Namespace: " OCI_NAMESPACE
    fi
    ;;
  all)
    echo -e "${BLUE}Deploying to all cloud providers${NC}"
    AWS=true
    GCP=true
    AZURE=true
    OCI=true
    
    if [ -z "$GCP_PROJECT_ID" ]; then
      read -p "Enter your GCP Project ID: " GCP_PROJECT_ID
    fi
    
    if [ -z "$OCI_COMPARTMENT_ID" ]; then
      read -p "Enter your OCI Compartment ID: " OCI_COMPARTMENT_ID
    fi
    
    if [ -z "$OCI_NAMESPACE" ]; then
      read -p "Enter your OCI Namespace: " OCI_NAMESPACE
    fi
    ;;
  *)
    echo -e "${RED}Usage: $0 [aws|gcp|azure|oci|all]${NC}"
    exit 1
    ;;
esac

# Create the temporary tfvars file
create_tfvars

# Initialize Terraform if needed
if [ ! -d ".terraform" ]; then
  echo -e "${BLUE}Initializing Terraform...${NC}"
  terraform init
fi

# Run Terraform
echo -e "${BLUE}Planning deployment...${NC}"
terraform plan -var-file=temp.tfvars

# Confirm deployment
read -p "Do you want to apply these changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${BLUE}Applying changes...${NC}"
  terraform apply -var-file=temp.tfvars -auto-approve
  
  # Show outputs
  echo -e "${GREEN}Deployment completed! Resources created:${NC}"
  terraform output
else
  echo -e "${BLUE}Deployment cancelled.${NC}"
fi

# Clean up
rm temp.tfvars
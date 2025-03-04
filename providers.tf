# AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Owner      = var.owner
      Managed_by = "Terraform"
      Environment = var.environment
    }
  }
}

# GCP Provider - Only configure if enabled
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Azure Provider - Only configure if enabled
provider "azurerm" {
  features {}
}

# OCI Provider - Only configure if enabled
provider "oci" {
  region = var.oci_region
  # Note: Authentication for OCI typically uses environment variables or ~/.oci/config
}
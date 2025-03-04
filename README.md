# terraform-learning

## Multi-Cloud Storage Deployment

This Terraform project provides infrastructure as code for deploying storage solutions (buckets) across multiple cloud providers:

- AWS S3 Buckets
- Google Cloud Storage Buckets
- Azure Storage Accounts with Containers
- Oracle Cloud Infrastructure Object Storage Buckets

## Features

- Deploy to one or multiple cloud providers simultaneously
- Toggle providers on/off using a single configuration variable
- Consistent naming and tagging across platforms
- Security best practices applied (encryption, access controls)

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed (v1.10.0 or newer)
2. Authentication configured for each cloud provider you want to use:
   - AWS: AWS CLI configured or environment variables
   - GCP: gcloud CLI configured or service account key
   - Azure: Azure CLI logged in or service principal
   - OCI: OCI CLI configured or API key

## Setup and Configuration

1. Clone this repository
2. Create a `terraform.tfvars` file based on the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edit the `terraform.tfvars` file to:
   - Set your desired bucket name
   - Enable/disable specific cloud providers
   - Configure region settings
   - Add required credentials for each provider

## Usage

### Initialize Terraform

```bash
terraform init
```

### Preview the deployment plan

```bash
terraform plan
```

### Deploy the infrastructure

```bash
terraform apply
```

### Destroy the infrastructure

```bash
terraform destroy
```

## Enabling/Disabling Cloud Providers

In your `terraform.tfvars` file, set the following to control which providers are used:

```hcl
cloud_providers = {
  aws   = true    # Set to true to deploy AWS S3 bucket
  gcp   = false   # Set to true to deploy Google Cloud Storage bucket
  azure = false   # Set to true to deploy Azure Storage account and container
  oci   = false   # Set to true to deploy OCI Object Storage bucket
}
```

## Provider-Specific Configuration

### AWS
- Region: Set `aws_region` variable
- Authentication: Use AWS CLI configuration or environment variables

### Google Cloud Platform
- Project ID: Set `gcp_project_id` variable
- Region: Set `gcp_region` variable
- Authentication: Use gcloud CLI configuration or GOOGLE_APPLICATION_CREDENTIALS

### Azure
- Location: Set `azure_location` variable
- Resource Group: Set `azure_resource_group` variable  
- Authentication: Use az login or service principal credentials

### Oracle Cloud Infrastructure
- Region: Set `oci_region` variable
- Compartment ID: Set `oci_compartment_id` variable
- Namespace: Set `oci_namespace` variable
- Authentication: Use OCI CLI configuration or API key
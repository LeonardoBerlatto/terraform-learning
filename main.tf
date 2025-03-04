terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
      configuration_aliases = [google]
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [azurerm]
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
      configuration_aliases = [oci]
    }
  }
}

# AWS S3 Bucket
resource "aws_s3_bucket" "image_bucket" {
  count  = var.cloud_providers.aws ? 1 : 0
  
  bucket = var.bucket_name

  tags = {
    Name        = "Image Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.cloud_providers.aws ? 1 : 0
  
  bucket = aws_s3_bucket.image_bucket[0].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count  = var.cloud_providers.aws ? 1 : 0
  
  bucket = aws_s3_bucket.image_bucket[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.cloud_providers.aws ? 1 : 0
  
  bucket = aws_s3_bucket.image_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Google Cloud Storage Bucket
resource "google_storage_bucket" "image_bucket" {
  count  = var.cloud_providers.gcp ? 1 : 0
  
  name          = var.bucket_name
  location      = var.gcp_region
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  labels = {
    owner       = lower(replace(var.owner, " ", "-"))
    environment = var.environment
    managed-by  = "terraform"
  }
}

# Azure Storage Account and Container
resource "azurerm_resource_group" "storage_rg" {
  count     = var.cloud_providers.azure ? 1 : 0
  
  name      = "${var.azure_resource_group}-${var.environment}"
  location  = var.azure_location

  tags = {
    Owner       = var.owner
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_account" "storage_account" {
  count                    = var.cloud_providers.azure ? 1 : 0
  
  name                     = lower(replace(substr(replace(var.bucket_name, "-", ""), 0, 24), ".", ""))
  resource_group_name      = azurerm_resource_group.storage_rg[0].name
  location                 = azurerm_resource_group.storage_rg[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Owner       = var.owner
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_container" "image_container" {
  count                 = var.cloud_providers.azure ? 1 : 0
  
  name                  = "images"
  storage_account_id    = azurerm_storage_account.storage_account[0].id
  container_access_type = "private"
}

# OCI Object Storage Bucket
resource "oci_objectstorage_bucket" "image_bucket" {
  count          = var.cloud_providers.oci ? 1 : 0
  
  compartment_id = var.oci_compartment_id
  name           = var.bucket_name
  namespace      = var.oci_namespace
  
  versioning     = "Enabled"
  
  # Make the bucket private
  access_type = "NoPublicAccess"
  
  freeform_tags = {
    "Owner"       = var.owner
    "Environment" = var.environment
    "ManagedBy"   = "Terraform"
  }
}
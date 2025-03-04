# AWS Outputs
output "aws_bucket_name" {
  description = "AWS S3 bucket name"
  value       = var.cloud_providers.aws ? aws_s3_bucket.image_bucket[0].bucket : "AWS not enabled"
}

output "aws_bucket_arn" {
  description = "AWS S3 bucket ARN"
  value       = var.cloud_providers.aws ? aws_s3_bucket.image_bucket[0].arn : "AWS not enabled"
}

# GCP Outputs
output "gcp_bucket_name" {
  description = "Google Cloud Storage bucket name"
  value       = var.cloud_providers.gcp ? google_storage_bucket.image_bucket[0].name : "GCP not enabled"
}

output "gcp_bucket_url" {
  description = "Google Cloud Storage bucket URL"
  value       = var.cloud_providers.gcp ? google_storage_bucket.image_bucket[0].url : "GCP not enabled"
}

# Azure Outputs
output "azure_storage_account_name" {
  description = "Azure Storage Account name"
  value       = var.cloud_providers.azure ? azurerm_storage_account.storage_account[0].name : "Azure not enabled"
}

output "azure_container_name" {
  description = "Azure Storage Container name"
  value       = var.cloud_providers.azure ? azurerm_storage_container.image_container[0].name : "Azure not enabled"
}

# OCI Outputs
output "oci_bucket_name" {
  description = "OCI Object Storage bucket name"
  value       = var.cloud_providers.oci ? oci_objectstorage_bucket.image_bucket[0].name : "OCI not enabled"
}
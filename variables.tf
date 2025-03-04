variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
  default     = "temp-image-bucket-leonardo-berlatto"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "LeonardoBerlatto"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "cloud_providers" {
  description = "Enable/disable specific cloud providers"
  type        = map(bool)
  default     = {
    aws    = true
    gcp    = false
    azure  = false
    oci    = false
  }
}

# AWS Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

# Azure Variables
variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "eastus"
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = "storage-rg"
}

# OCI Variables
variable "oci_region" {
  description = "OCI region"
  type        = string
  default     = "us-ashburn-1"
}

variable "oci_compartment_id" {
  description = "OCI compartment ID"
  type        = string
  default     = ""
}

variable "oci_namespace" {
  description = "OCI Object Storage namespace"
  type        = string
  default     = ""
}
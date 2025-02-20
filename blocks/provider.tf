provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      owner       = "LeonardoBerlatto"
      managed_by  = "Terraform"
    }
  }
}

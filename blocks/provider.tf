provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Owner       = "LeonardoBerlatto"
      Managed_by  = "Terraform"
    }
  }
}

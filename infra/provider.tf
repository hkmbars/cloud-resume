# Terraform block specifies the required providers and their versions
terraform {
  required_providers {
    aws = {                                         # Defines AWS as the required provider
      source  = "hashicorp/aws"                     # Specifies that the AWS provider comes from HashiCorp
      version = "~> 5.0"                            # Allows any AWS provider version 5.x
    }
  }
}

# Configures the AWS provider with authentication details
provider "aws" {
  region                   = "ap-southeast-1"       # Specifies the AWS region to deploy resources
  shared_credentials_files = ["~/.aws/credentials"] # Uses AWS credentials stored in the local AWS credentials file; ~ = indicates home directory
  profile                  = "Hannah"               # Specifies which profile to use from the credentials file
}
# Configure the AWS Provider
terraform {
  required_providers {  
     aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"  
    } 
  } 
  required_version = ">= 1.3.0"
}

provider "aws" {
  alias = "eu-central-1" 
  region = "eu-central-1"
}
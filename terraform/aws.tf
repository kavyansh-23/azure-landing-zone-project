provider "aws" {
  region = "eu-west-1"
  # Skipping credentials for local CI validation
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

resource "aws_vpc" "multi_cloud_vpc" {
  cidr_block = "10.2.0.0/16"
  
  tags = {
    Name = "minimal-aws-vpc"
  }
}
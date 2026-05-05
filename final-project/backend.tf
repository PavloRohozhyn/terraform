terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }


  # aws s3 mb s3://rohozhyn-final-project --region us-east-1

  backend "s3" {
    bucket = "rohozhyn-final-project"
    key = "final-project/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

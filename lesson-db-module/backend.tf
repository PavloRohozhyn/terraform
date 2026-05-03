terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }


  # aws s3 mb s3://rohozhyn-lesson-db-module --region us-east-1

  backend "s3" {
    bucket = "rohozhyn-lesson-db-module"
    key = "lesson-db-module/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }


  # aws s3 mb s3://rohozhyn-lesson-8-9 --region us-east-1

  backend "s3" {
    bucket = "rohozhyn-lesson-8-9"
    key = "lesson-8-9/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }


  # aws s3 mb s3://rohozhyn-lesson-7 --region us-east-1

  backend "s3" {
    bucket = "rohozhyn-lesson-7"
    key = "lesson-7/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}

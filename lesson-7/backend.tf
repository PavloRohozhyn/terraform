terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "rohozhyn-lesson-5"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    encrypt        = true
  }
}

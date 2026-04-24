# provider
provider "aws" {
  region = "us-east-1"
}

# s3 bucket
module "s3_backend" {
  source = "./modules/s3_backend"
  bucket_name = "rohozhyn-lesson-5"
  create_bucket = false # disable create 
  dynamodb_table_name  = "terraform-locks"
  environment = "dev"
}

# VPC module
module "vpc" {
  source = "./modules/vpc"
  environment         = "dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# ECR module
module "ecr" {
  source          = "./modules/ecr"
  environment     = "dev"
  repository_name = "lesson-5-test"
  scan_on_push    = true
}
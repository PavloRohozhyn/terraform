terraform {
  backend "s3" {
    bucket         = "test-s3-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    # (depricated) dynamodb_table = "terraform-locks"
    use_lockfile = true 
    profile        = "default"
    encrypt        = true
  }
}


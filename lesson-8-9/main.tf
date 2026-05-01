# aws provider
provider "aws" {
  region = "us-east-1"
}

# helm provider - configuration via outputs EKS (outputs.tf)
# this is allowed helm wait when cluster will created
provider "helm" {
  kubernetes = {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command = "aws"
    }
  }
}

# s3 bucket
module "s3_backend" {
  source = "./modules/s3_backend"
  bucket_name = "rohozhyn-lesson-8-9"
  create_bucket = false 
  dynamodb_table_name = "terraform-locks"
  environment = "dev"
}

# virtual private
module "vpc" {
  source = "./modules/vpc"
  environment = "dev"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# elastic container registry
module "ecr" {
  source = "./modules/ecr"
  environment = "dev"
  repository_name = "lesson-8-9-test"
  scan_on_push = true
}

# eks
module "eks" {
  source = "./modules/eks"
  environment = "dev"
  cluster_name = "lesson-8-9-test-kuber"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}


# jenkins
module "jenkins" {
  source = "./modules/jenkins"
  environment = "dev"
  cluster_name = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  ecr_repository    = module.ecr.repository_url 
  storage_class     = "gp2"
  kubeconfig        = "~/.kube/config" 
  depends_on = [module.eks]
}

# argocd
module "argo_cd" {
  source = "./modules/argo_cd"
  argo_cd_namespace = "argocd"
  chart_version = "5.46.4"
  repo_url = "https://github.com/PavloRohozhyn/terraform.git" 
  depends_on = [module.eks] 
}

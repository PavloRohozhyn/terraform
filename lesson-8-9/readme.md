[Back to list](./../readme.md)

[Task Definition](./task/readme.md)

# Terraform for AWS

- S3 Bucket for state
- Dynamydb for lock (only one person can works)
- VPC public (3 items) and private (3 items) subnets
- ECR (Elastic Container Registry) for Docker-images.
- Elastic IP (1 item)
- NAT Gateway (for Internet access from private subnets)
- EKS (Elastic Kubernetes Service)
- `new` Jenkins (for build and push docker container to ECR)
- `new` ArgoCD (sync cluster-kuber django-app, if git codebase was changed, like new PR in main branch )

First off all im creating `S3 bucket`, im use next aws terminal command

```
$ aws s3api create-bucket --bucket rohozhyn-lesson-8-9 --region us-east-1

```

![bucket s3](./imgs/aws-s3.png)

then

```
terraform init
```

![terraform init](./imgs/terraform-init.png)

```
terraform plan
```

![terraform plan](./imgs/terraform-plan.png)

Before command `terraform apply` im preparing django application from `lessons 4`. Im create independent repo with django application (<a href="https://github.com/PavloRohozhyn/django-app-for-terraform.git">django-app-for-terraform</a>) and create there Jenkinsfile for CI/CD process

```
terraform apply

```

![terraform apply](./imgs/terraform-apply.png)


And NOW! lets check what was created ))), firstly update kuberconfig because we have a new kubernetes cluster

```
aws eks update-kubeconfig --name dev-lesson-8-9-test-kuber
```

VPC

![aws vpc](./imgs/aws-vpc.png)

SUBNETS

![aws subnets](./imgs/aws-subnets.png)

APP in ECR

![aws ecr](./imgs/aws-ecr.png)

EKS

![aws kubernetes list](./imgs/kubernetes-1.png)

![aws kubernetes spec](./imgs/kubernetes-2.png)




!!! DONT FORGET `helm uninstall` firstly

```
terraform destroy
```

![terraform destroy](./imgs/terraform-destroy.png)

After this command all data will be deleted `BUT` not `S3 bucket`, `S3` bucket should deleted manually (use `AWS` web console)

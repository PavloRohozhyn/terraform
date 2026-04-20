[Back to list](./../readme.md)

[Task Definition](./task/readme.md)

# Terraform for AWS

- S3 Bucket for state
- Dynamydb for lock (only one person can works)
- VPC public (3 items) and private (3 items) subnets
- ECR (Elastic Container Registry) for Docker-images.
- Elastic IP (1 item)
- NAT Gateway (for Internet access from private subnets)

Sometimes when S3 doesnt created we can retrieve en error, im use next

```
aws s3 mb s3://my-uniq-bucket-name

```

![bucket s3](./imgs/bucket_s3.png)

then

```
terraform init
```

![terraform init](./imgs/terraform_init.png)

```
terraform plan
```

![terraform plan](./imgs/terraform_plan.png)

```
terraform apply

```

![terraform apply](./imgs/terraform_apply.png)

## Terraform Apply Result

### VPC

![vpc](./imgs/vpc.png)

### ElasticIP

![elastic ip](./imgs/elastic_ip.png)

### NAT Gateway

![nat](./imgs/nat.png)

### Elastic Container Service

![ecs](./imgs/ecs.png)

### Dynamo DB

![dynamodb](./imgs/dynamodb.png)

```
terraform destroy
```

![terraform destroy](./imgs/terraform_destroy.png)

After this command all data will be deleted `BUT` not S3 bucket, S3 bucket should deleted manually (use AWS web console)

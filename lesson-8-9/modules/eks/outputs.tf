# 1. Ендпоінт (використовуємо назву ресурсу з вашого eks.tf, припустимо це "main")
output "cluster_endpoint" {
  description = "EKS API endpoint"
  value = aws_eks_cluster.this.endpoint
}

# 2. Дані сертифіката (важливо для Helm провайдера)
output "cluster_ca_certificate" {
  description = "CA data for the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

# 3. Назва кластера
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

# 4. IAM Роль вузлів (потрібна для налаштування прав Jenkins/Kaniko)
output "node_role_arn" {
  description = "IAM role ARN for EKS Worker Nodes"
  value       = aws_iam_role.node_role.arn
}

# 5. OIDC для налаштування прав сервіс-акаунтів (IRSA)
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.oidc.url
}
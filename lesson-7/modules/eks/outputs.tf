# kubernetes endpoint
output "cluster_endpoint" {
  description = "kubernetes endpoint"
  value = aws_eks_cluster.main.endpoint
}
# kubernetes id
output "cluster_id" {
  description = "ID of kubernetes"
  value = aws_eks_cluster.main.id
}

# kubernetes cert
output "kubeconfig_certificate_authority_data" {
  description = "kubernetes cert"
  value = aws_eks_cluster.main.certificate_authority[0].data
}

# kubernetes name
output "cluster_name" {
  description = "name of kubernetes"
  value = aws_eks_cluster.main.name
}

# 1. Створюємо Service Account для Jenkins з доступом до AWS (IRSA)
resource "kubernetes_service_account_v1" "jenkins" {
  metadata {
    name      = "jenkins-admin"
    namespace = "jenkins"
    annotations = {
      "://amazonaws.com" = aws_iam_role.jenkins_ecr_role.arn
    }
  }
}

# 2. IAM роль, щоб Jenkins міг пушити образи в ECR
resource "aws_iam_role" "jenkins_ecr_role" {
  name = "${var.environment}-jenkins-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_url, "https://", "")}:sub": "system:serviceaccount:jenkins:jenkins-admin"
        }
      }
    }]
  })
}

# Додаємо права PowerUser для ECR
resource "aws_iam_role_policy_attachment" "jenkins_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.jenkins_ecr_role.name
}

# 3. Встановлюємо Jenkins через Helm
resource "helm_release" "jenkins" {
  name             = "jenkins"
  repository = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = "jenkins"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  set = [{
    name  = "controller.serviceAccount.name"
    value = kubernetes_service_account_v1.jenkins.metadata[0].name
  }]
}


data "kubernetes_service_v1" "jenkins_svc" {
  metadata {
    name      = helm_release.jenkins.name
    namespace = helm_release.jenkins.namespace
  }

  depends_on = [helm_release.jenkins]
}
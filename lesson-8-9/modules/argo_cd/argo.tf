resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm" 
  chart = "argo-cd"
  version = var.chart_version # Використовуйте змінну
  namespace = "argocd"
  create_namespace = true
  values = [file("${path.module}/values.yaml")]
}

resource "helm_release" "argocd_apps" {
  name = "argocd-apps"
  chart = "${path.module}/charts"
  namespace = "argocd"
  depends_on = [helm_release.argocd]

  set = [{
    name  = "repoURL"
    value = var.repo_url
  }]
}

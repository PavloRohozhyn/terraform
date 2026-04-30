variable "argo_cd_namespace" {
  description = "The namespace Argo CD."
  type = string
  default = "argocd"
}

variable "chart_version" {
  description = "The version of the Argo CD"
  type = string
  default = "5.5.0"
}

variable "repo_url" {
  description = "ArgoCD for monitoring"
  type = string
}

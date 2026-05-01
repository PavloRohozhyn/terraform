output "admin_password" {
  description = "Admin pass for Jenkins"
  value = "admin123"
  sensitive = true
}

output "jenkins_url" {
  description = "URL of the Jenkins service"
  value = format("http://%s", data.kubernetes_service_v1.jenkins_svc.status[0].load_balancer[0].ingress[0].hostname)
}

output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

variable "github_token" {
  description = "GitHub Personal Access Token for Jenkins"
  type = string
  sensitive = true # hide pass in log (****) 
}
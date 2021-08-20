variable "repo_name" {
  description = "Github repo name"
  type        = string
}

variable "github_pat" {
  description = "Github Personal Access Token"
  type        = string
}

variable "github_org" {
  description = "Github organisation"
  type        = string
}

variable "terraform_directory" {
  description = "Terraform directory"
  type        = string
}

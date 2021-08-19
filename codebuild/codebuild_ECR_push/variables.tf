variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}

variable "dockerfile" {
  type        = string
  description = "Dockerfile to be used to build image"
}

variable "deployment_role_name" {
  description = "The name of the role used to deploy the ECR image."
  type        = string
}

variable "codebuild_service_role_name" {
  description = "The role code build uses to access other AWS services."
  type        = string
}

variable "codebuild_image" {
  description = "The image that CodeBuild will use, including the tag."
  type        = string
}

variable "build_context" {
  description = "The absolute path to folder to run docker build from."
  type        = string
}

variable "image_tag" {
  description = "The name you want to tag the image."
  type        = string
  default     = "latest"
}

variable "ecr_image_repo_name" {
  description = "The name you want to repo name the image."
  type        = string
}


variable "docker_hub_username" {
  description = "The username used to authenticate with Docker Hub"
  type        = string
}

variable "docker_hub_password" {
  description = "The password used to authenticate with Docker Hub"
  type        = string
  # sensitive   = true # Terraform 0.14 only, unfortunately
}

variable "aws_accounts" {
  type = map(object({
    environment    = string
    aws_account_id = number
  }))
}

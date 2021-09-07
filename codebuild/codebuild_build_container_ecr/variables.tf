variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}

variable "stage_name" {
  description = "The name of the pipeline stage"
  type        = string
  default     = "default"
}

variable "action_name" {
  description = "The name of the pipeline stage action"
  type        = string
  default     = "default"
}

variable "dockerfile" {
  type        = string
  description = "Dockerfile to be used to build image"
}

variable "deployment_account_id" {
  description = "The AWS account id where you are deploying to ECR image to."
  type        = string
}

variable "deployment_role_name" {
  description = "The name of the role used to deploy the ECR image."
  type        = string
}

variable "codebuild_service_role_name" {
  description = "The role code build uses to access other AWS services."
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

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}

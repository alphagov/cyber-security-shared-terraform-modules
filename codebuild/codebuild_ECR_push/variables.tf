variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}

variable "ecr_dockerfile" {
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

variable "ecr_context" {
  description = "The absolute path to folder to run docker build from."
  type        = string
}

variable "ecr_image_tag" {
  description = "The name you want to tag the image. (Default: latest)"
  type        = string
  default     = "latest"
}

variable "ecr_image_repo_name" {
  description = "The name you want to repo name the image."
  type        = string
}

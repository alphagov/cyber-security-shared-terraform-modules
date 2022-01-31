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

variable "codebuild_service_role_name" {
  description = "The role code build uses to access other AWS services."
  type        = string
}

variable "deploy_key" {
  description = "The deploy key for the repo you want to access."
  type        = string
}

variable "codebuild_image" {
  description = "the image in which you want to run the codebuild task"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
  type        = string
}

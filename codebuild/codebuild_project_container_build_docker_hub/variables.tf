variable "docker_hub_repo" {
  type        = string
  description = "Name of the Dockerhub repo"
}

variable "image_tag" {
  type        = string
  description = "Image tag, eg; docker-image:1.0 (Default: latest)"
  default     = "latest"
}

variable "build_context" {
  type        = string
  description = "Path to the folder to run docker build from"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}

variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}

variable "service_role_name" {
  type        = string
  description = "name of the service role"
}

variable "dockerfile" {
  type        = string
  description = "Path to the dockerfile"
}

variable "docker_hub_username" {
  type        = string
  description = "Dockerhub Username"
}

variable "docker_hub_password" {
  type        = string
  description = "Dockerhub password"
  sensitive   = true
}

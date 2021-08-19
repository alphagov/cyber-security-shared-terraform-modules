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

variable "docker_context" {
  type        = string
  description = "Docker context"
}

# variable "docker_hub_credentials" {
#   description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
#   type        = string
# }

variable "docker_hub_username" {
  type = string
}

variable "docker_hub_password" {
  type = string
}

variable "codebuild_src_dir" {
  type = string
}

variable "docker_image_tag" {
  type = string
}

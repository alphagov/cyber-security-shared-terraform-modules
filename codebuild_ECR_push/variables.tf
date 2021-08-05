variable "region_name" {
  type    = string
  default = "eu-west-2"
}
variable "environment" {
  type        = string
  description = "Enviroment this module will be ran"
}

variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
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

variable "codebuild_image" {
  description = "The image that CodeBuild will use, including the tag."
  type        = string
}

variable "ecr_context" {
  description = "The absolute path to folder to run docker build from."
  type        = string
}

variable "ecr_image_tag" {
  description = "The name you want to tag the image."
  type        = string
}

variable "dockerhub_username" {
  description = "The name of the Docker username in SSM"
  type        = string
  default     = "docker_hub_credentials:username"
}

variable "dockerhub_password" {
  description = "The name of the Docker password in SSM"
  type        = string
  default     = "docker_hub_credentials:password"
}

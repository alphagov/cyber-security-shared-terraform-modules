variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable "deployment_account_id" {
  description = "the account into which the terraform will be deployed"
  type        = string
}

variable "deployment_role_name" {
  description = "the role used to deploy the terraform"
  type        = string
}

variable "sts_assume_role_duration" {
  description = "duration for STS AssumeRole"
  type        = number
}

variable "terraform_directory" {
  description = "the location where code pipeline will runn terraform from"
  type        = string
}

variable "backend_var_file" {
  description = "(Optional) the filename for the backend tfvars"
  type        = string
  default     = ""
}

variable "codebuild_service_role_name" {
  description = "the role code build uses to access other AWS services"
  type        = string
}

variable "codebuild_image" {
  description = "The image that CodeBuild will use, including the tag."
  type        = string
}

variable "pipeline_name" {
  description = "The name of the pipeline this project will be a part of"
  type        = string
}

variable "environment" {
  description = "e.g. staging, production"
  type        = string
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
  type        = string
}

variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable "terraform_version" {
  description = "the tf version you want to use"
  type        = string
  default     = "0.12.31"
}

variable "terraform_directory" {
  description = "the location where code pipeline will runn terraform from"
  type        = string
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

variable "environment" {
  description = "e.g. staging, production"
  type        = string
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Pass through parent service tags to CodeBuild project resource"
  default     = {}
}

variable "copy_artifacts" {
  type        = list(map(string))
  description = "A list of maps containing artifacts to import with the artifact src and destination file path"
  default     = []
}
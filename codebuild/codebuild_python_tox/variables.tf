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

variable "python_source_directory" {
  description = "Directory name where the Python source code is located"
  type        = string
}

variable "python_version" {
  description = "Python version to use"
  type        = string
}

variable "environment" {
  description = "e.g. staging, production"
  type        = string
}

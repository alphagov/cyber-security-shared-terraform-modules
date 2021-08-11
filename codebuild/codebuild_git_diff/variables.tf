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

# variable "github_pat" {
#   description = "The pat token to authorise your github account."
#   type        = string
# }

variable "github_org" {
  description = "The github org where your repo is."
  type        = string
  default     = "alphagov"
}

variable "repo_name" {
  description = "The repository on github."
  type        = string
}

variable "output_filename" {
  description = "The relative file where you want to save the git diff information."
  type        = string
}

# variable "artifact_bucket" {
#   description = "S3 path where the artifact will be stored."
#   type        = string
# }

variable "codebuild_image" {
  description = ""
  type        = string
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
  type        = string
}

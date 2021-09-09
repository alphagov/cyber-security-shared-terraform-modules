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

variable "github_pat" {
  description = "The pat token to authorise your github account."
  type        = string
}

variable "github_org" {
  description = "The github org where your repo is."
  type        = string
  default     = "alphagov"
}

variable "repo_name" {
  description = "The repository on github."
  type        = string
}

variable "output_artifact_path" {
  description = "the S3 path to store the output atrifact"
  type        = string
  default     = "changed_files.json"
}

variable "codebuild_image" {
  description = ""
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

variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable environment {
  description = "e.g. staging, production"
  type        = string
}

variable "codebuild_service_role_name" {
  description = "the role code build uses to access other AWS services"
  type        = string
}

variable deployment_account_id {
  description = "the account into which the terraform will be deployed"
  type        = string
}

variable deployment_role_name {
  description = "the role used to deploy the terraform"
  type        = string
}

variable "docker_hub_credentials" {
  description = "The name of the Secrets Manager secret that contains the username and password for the Docker Hub"
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

variable "service_name" {
  description = "The name of the Terraform output that contains the name of the service"
  type = string
}

variable "network_config_name" {
  description = "The name of the Terraform output that has the network configuration"
  type = string
}

variable "output_filename" {
  description = "The filename that contains the Terraform output from a previous job"
  type = string
}

variable "ecs_task_name" {
  description = "The name of the Terraform output that has the ECS task ARN"
  type        = string
}

variable "group_name" {
  description = "The name of the Terraform output that has the ECS task group"
  type        = string
}

variable "cluster_name" {
  description = "The name of the Terraform output that has the ECS task cluster"
  type        = string
}

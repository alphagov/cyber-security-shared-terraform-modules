variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable "deployment_account_id" {
  description = "the account into which the terraform will be deployed"
  type = string
}

variable "deployment_role_name" {
  description = "the role used to deploy the terraform"
  type = string
}

variable "terraform_directory" {
  description = "the location where code pipeline will runn terraform from"
  type = string
}

variable "backend_var_file" {
  description = "(Optional) the filename for the backend tfvars"
  type = string
  default = ""
}

variable "apply_var_file" {
  description = "(Optional) the filename for the apply tfvars"
  type = string
  default = ""
}

variable "codebuild_service_role_name" {
  description = "the role code build uses to access other AWS services"
  type = string
}

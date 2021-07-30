variable "region_name" {
  type    = string
  default = "eu-west-2"
}

variable "deployment_account_id" {
  type = string
}

variable "deployment_role_name" {
  type = string
}

variable "terraform_path" {
  type = string
}

variable "backend_var_file" {
  type = string
  default = ""
}

variable "apply_var_file" {
  type = string
  default = ""
}

variable "execution_role_name" {
  type = string
}
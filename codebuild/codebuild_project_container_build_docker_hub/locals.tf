# locals {
#   dockerhub_creds = jsondecode(
#     data.aws_secretsmanager_secret_version.dockerhub_creds.secret_string
#   )
# }
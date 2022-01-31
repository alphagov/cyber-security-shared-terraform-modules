# Build SSH config

Enable terraform to retrieve a module from a private repo by creating a local
SSH config

## How it works

Gets a deploy key from SSM
Creates a .ssh/config pointing to the deploy key
Save as an output artifact (defined in the codepipeline action)

## Example usage

```
module "codebuild_build_ssh_config" {
  source                      = "github.com/alphagov/cyber-security-shared-terraform-modules//codebuild/codebuild_build_ssh_config"
  codebuild_service_role_name = data.aws_iam_role.pipeline_role.name
  codebuild_image             = "user/container-image:tag"
  pipeline_name               = "CodePipelineName"
  stage_name                  = "CodePipelineStageName"
  action_name                 = "CodePipelineActionName"
  environment                 = var.environment
  deploy_key                  = var.ssm_deploy_key
  docker_hub_credentials      = var.docker_hub_creds
  tags                        = local.tags
}
```

Creates a `.ssh` directory in the output artifact containing the deploy key and
a config file referencing the deploy key to be used for github.com URLs.

```
.ssh
  /config
  /deploy_key
```

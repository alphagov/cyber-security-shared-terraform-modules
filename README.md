# Cyber Security shared Terraform Modules

## CodePipeline and CodeBuild

We have created a number of modules for running common tasks in CodePipeline.

### Containers

These modules use scripts from a public container image
[gdscyber/cyber-security-cd-base-image](https://hub.docker.com/r/gdscyber/cyber-security-cd-base-image)

The code for the image is here: [https://github.com/alphagov/cyber-security-concourse-base-image](https://github.com/alphagov/cyber-security-concourse-base-image)

The image does things like installing common requirements like pyenv and tfenv.

It also has some helper scripts for doing common tasks like assuming a role into
an AWS account.

The modules allow you to specify a different container image but if you do this
you will need the dependencies and helper scripts to use the modules so you
would need to do a multi-stage container build to pull in the bin directory and
install the same dependencies.

### Modules

#### Terraform
* [Terraform Validate and Apply](./codebuild/codebuild_apply_terraform)
* [Terraform Validate only](./codebuild/codebuild_validate_terraform)

#### Authentication
If something like terraform needs to retrieve a module from a private repository
this allows you to setup an SSH config file with a readonly deploy key to use
when retrieving the module source.
* [Build SSH Config](./codebuild/codebuild_build_ssh_config)

#### Building containers
* [Build Docker Hub Container](./codebuild/codebuild_build_container_docker_hub)
* [Build ECR Container](./codebuild/codebuild_build_container_ecr)

#### Selectively run pipeline
These modules allow you to query the changed files from a recently merged PR
so that you can decide whether tasks in the pipeline are required.
* [Get changed files](./codebuild/codebuild_get_changed_file_list)
* [Get actions required](./codebuild/codebuild_get_actions_required)

#### Monitoring
* [CloudWatch event rule](./cloudwatch/cloudwatch_report_codepipeline_status)

## IAM
### gds_security_audit
A role implementing the AWS `SecurityAudit` managed policy along with a few
additions which trusts an intermediary role in the organization account.

output "project_name" {
  #value = aws_codebuild_project.code_pipeline_ecr_container[each.key].name
  value = tomap({
    for k, v in aws_codebuild_project.code_pipeline_ecr_container : k => v.name
  })
}

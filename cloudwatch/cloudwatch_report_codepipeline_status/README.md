# CodePipeline Healthcheck Event Rule

This module creates a CloudWatch/EventBridge Event Rule, an SNS topic target for that rule, and a
policy for the SNS topic to allow the event rule to publish to it.

The Event Rule watches a given CodePipeline pipeline for any state changes, sending those state
changes to the SNS topic.

## Example Usage
```terraform
module "codepipeline-healthcheck" {
  source                         = "github.com/alphagov/cyber-security-shared-terraform-modules//cloudwatch/cloudwatch_report_codepipeline_status"
  pipeline_name                  = "example_pipeline
  health_notification_topic_name = "example_topic"
}

resource "aws_codepipeline" "example_pipeline" {
  name = "example_pipeline"
  ...
}

resource "aws_sns_topic" "example_topic" {
  name = "example_topic"
  ...
}
```

## Argument Reference
The following arguments are required:
- `pipeline_name` - The name of the CodePipeline pipeline to track the state of.
- `health_notification_topic_name` - The name of the SNS topic to publish to.

resource "aws_cloudwatch_event_rule" "run_schedule" {
  name                = "schedule-cloudwatch-event-rule-for-${var.pipeline_name}"
  description         = "Schedule to run Cloudwatch Event Rule"
  schedule_expression = var.event_rule_schedule
}

resource "aws_cloudwatch_event_target" "trigger_lambda_for_rule_schedule" {
  rule      = aws_cloudwatch_event_rule.run_schedule.name
  target_id = var.lambda_name
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.run_schedule.arn
}

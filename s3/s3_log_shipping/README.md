# S3 to Lambda subscription module

This module allows you to subscribe an SQS queue & S3 bucket to a
lambda that processes s3 logs. It contains the required policies to attach to the
resources to grant access.

## Instructions

### Import module
Import the module into your terraform

``` hcl
module "s3_log_shipping" {
  source  = "github.com/alphagov/cyber-security-shared-terraform-modules//s3/s3_log_shipping"
  sqs_arn = aws_sqs_queue.YOUR_SQS.arn
  s3_name  = aws_s3_bucket.YOUR_BUCKET.id
}
```

### Apply IAM policies
Combine the `module.s3_log_shipping.s3_policy` S3 bucket policy with
any other policies you have for the source bucket and then attach the
combined policy.

``` hcl
data "aws_iam_policy_document" "s3_combined" {
   source_policy_documents = [
     data.aws_iam_policy_document.YOUR_BUCKET_POLICY.json,
     module.s3_log_shipping.s3_policy
   ]
 }

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.YOUR_BUCKET.id
  policy = data.aws_iam_policy_document.s3_combined.json
}
```

Repeat the policy combination and application for the SQS queue.

``` hcl
data "aws_iam_policy_document" "sqs_combined" {
  source_policy_documents = [
    data.aws_iam_policy_document.YOUR_SQS_POLICY.json,
    module.s3_log_shipping.sqs_policy
  ]
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.YOUR_SQS.id
  policy    = data.aws_iam_policy_document.sqs_combined.json
}
```

## What the Lambda maintainers need to do afterwards

Once this is all set up, the maintainers of the s3 processor lambda
must subscribe the lambda to your SQS queue. One way to do so is the
following terraform:

``` hcl
resource "aws_lambda_event_source_mapping" "DESCRIPTION" {
  event_source_arn = "arn:aws:sqs:REGION:ACCOUNTID:QUEUENAME"
  function_name    = module.s3_processor.lambda_arn
}
```

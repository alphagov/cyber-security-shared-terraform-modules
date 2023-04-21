# S3 to Lambda subscription module

This module allows you to subscribe an SQS queue & S3 bucket to a
lambda that processes s3 logs. It contains the required policies to attach to the
resources to grant access.

**Note that in some cases the S3 Processor assumes your log files are gzipped -**
**if this is the case please ensure that they are.**

**TODO: Is this something we want to auto-detect instead?**

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

It is **incredibly important** that you update the object ownership settings on
your bucket to use `BucketOwnerEnforced` (or `BucketOwnerPreferred`, if you're
still using ACLs).  Otherwise, cross-account access will not work.

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
### Note for buckets encrypted with KMS
You will have to add the lambda execution role ARN to the policy of the KMS key
you use to encrypt the bucket with. For example:

```json
  ...
    {
      "Sid": "CSLS access",
      "Effect": "Allow",
      "Principal": {
          "AWS": [
              "arn:aws:iam::885513274347:role/csls_prodpython/csls_process_s3_logs_lambda_prodpython",
          ]
      },
      "Action": [
          "kms:Decrypt",
      ],
      "Resource": "*"
    },
```

## What the Lambda maintainers need to do afterwards
**TODO: Do we want to provide this statement/an entire KMS key as part of the S3**
**Log Shipping module?**

### Subscribe Lambda to SQS

Make sure that the CSLS team subscibes the SQS queue created with this module
to the S3 lambda in the the [CSLS production S3
deployment](https://github.com/alphagov/centralised-security-logging-service/tree/master/terraform/deployments/885513274347_prodpython/module-csls-python-s3.tf)

```hcl
resource "aws_lambda_event_source_mapping" "DESCRIPTION" {
  event_source_arn = "arn:aws:sqs:REGION:ACCOUNTID:QUEUENAME"
  function_name    = module.s3_processor.lambda_arn
}
```
### Routing

By default your data is routed to the index (`csls_unrecognised_data`).

This index has a short retention period and is not intended for
use.

This behaviour can be changed per log group by raising a PR to
add [config](kinesis_processor/s3_mapping.toml)
to the s3 processor lambda.

We expect this to be done by the Cyber Security Team as part of
the engagement process but you can submit PRs directly if you
prefer.

You cannot create an index dynamically. Before changing
the routing config you should ensure your target index
exists and has been appropriately configured for your
data.

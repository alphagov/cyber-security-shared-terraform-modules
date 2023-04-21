# S3 to Lambda subscription module

This module allows you to subscribe an S3 bucket to CSLS that processes S3 logs.

It defines the policies you need to attach to said bucket, to allow it to send bucket notifications
to an SQS queue which CSLS reads from, along with permissions to allow CSLS to get the log files
from the bucket.

**Note that in some cases the S3 Processor assumes your log files are gzipped -**
**if this is the case please ensure that they are.**

**TODO: Is this something we want to auto-detect instead?**

## Instructions

### Import module
Import the module into your terraform

``` hcl
module "s3_log_shipping" {
  source  = "github.com/alphagov/cyber-security-shared-terraform-modules//s3/s3_log_shipping"
  s3_processor_lambda_role = # To be provided by the Cyber team
  s3_processor_sqs_arn = # To be provided by the Cyber team
  bucket_name  = aws_s3_bucket.YOUR_BUCKET.id
  log_prefixes = # List of prefixes (*with* a trailing slash, if necessary) to where your logs are
                 # stored in the bucket (it's a list so you can have more than one different log
                 # type/source in the same bucket but create separate notifications)
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

### Add bucket to Lambda's SQS policy
The Cyber team then need to add the bucket to the Lambda's SQS policy by updating a `locals.tf`
file. Once that's been done, your S3 logs should start coming into Splunk! You'll need to do more
configuration to get them to the right index, but you should ask Cyber about that.

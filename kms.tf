data "aws_caller_identity" "current" {}

resource "aws_kms_key" "learncantrill" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  policy = jsonencode({
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::730335577638:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
})
}
#^this key policy only trusts the account user^

resource "aws_kms_alias" "catdog" {
  name          = "alias/cantrillssekey"
  target_key_id = aws_kms_key.learncantrill.key_id
}
resource "aws_s3_bucket" "catpicsref" {
  bucket = "tallshawnnetwork"

  tags = {
    Name        = "tallshawnnetwork"
     }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.catpicsref.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.catpicsref.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.catpicsref.id
  acl    = "public-read"
}

#this configuration will use the key suggested if when uploading an object there is no encryption method specified

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.catpicsref.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "cantrillssekey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpVzTaiQaTRWO4jRuFysccoCc1lFVW7KhfnhiYXgkoMTop0UtcdzZjGCkWr6B+1sGprrOoflzLvafuhckQaje7t24fXKU8gbQTjuFT5sXzEJfkz/y/JKJOYQb/xXXCXnKJw92wgKusu7kgFuBTjs/Cdun/N4BZ0Q9EHe75SgVfhDRkcsyNUgcPyDEfGy3C0xnfeYAhMQ0U71iSBmCyVcAm1WkUc7/UFuFM4muW+K5dUfTbTR7dSIPeom6ys4F2dIOi2jM+2y0BI6T4027Qd94axXWpEDm6dvx8hMS6m1BcW6r1teJkFFkx0VIVJDfRzWPpK8LrVAryCS4lvWAal9fR home@Homes-MBP.home"
}

import {
  to = aws_key_pair.deployer
  id = "deployer-key"
}
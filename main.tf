terraform {
  required_version = ">= 0.11.13"
}

variable "aws_region" {
  description = "AWS region"
  default = "us-gov-west-1"
}

variable "bucket_name" {
   description = "ajennings-govcloud"
   default = "ajennings-govcloud"
}

variable "bucket_acl" {
   description = "ACL for S3 bucket: private, public-read, public-read-write, etc"
   default = "public-read"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  acl    = "${var.bucket_acl}" 
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws-us-gov:kms:us-gov-west-1:919784536822:key/24ddabfc-c4a2-4323-bed5-220b4bb4b80d"
        sse_algorithm     = "aws:kms"
      }
    }
  }
 
  versioning {
    enabled = true
    mfa_delete = false
  }
  
  logging {
    target_bucket = "amanda-bucket"
  }
  
  tags {
    name        = "Amanda Test Bucket"
    Owner = "ajennings@hashicorp.com"
    website = "true"
    application_id = "456"
    stack_name = "ajennings"
    description = "ajennings"
    termination_date = "05/26/2019"
    created_by = "amanda"
    data_class = "protected"
    environment = "dev" 
  }
}

output "sse" {
  value = "${aws_s3_bucket.bucket.server_side_encryption_configuration.0.rule.0.apply_server_side_encryption_by_default.0.sse_algorithm}"
}

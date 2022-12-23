terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

module "s3_backup_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "firefoxc-backups-${var.project_name}"
  acl    = "private"
  
  putin_khuylo = true

  versioning = {
    enabled = true
  }

}

data "aws_iam_policy_document" "cli_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
}

resource "aws_iam_policy" "backup_user_policy" {
  name        = "firefoxc_backup_policy_${var.project_name}"
  path        = "/"
  description = "Policy document of permissions for the backup of firefoxc - ${var.project_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetBucketLocation",
          "s3:PutBucketVersioning",
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "${module.s3_backup_bucket.s3_bucket_arn}",
          "${module.s3_backup_bucket.s3_bucket_arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "backup_user_role" {
  name = "firefoxc_backup_role_${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.cli_assume_role_policy.json

  managed_policy_arns = [
    aws_iam_policy.backup_user_policy.arn
  ]

  tags = {
    project = var.project_name
    name = "backup_user_role"
  }
}

resource "aws_iam_user" "backup_user" {
  name = "firefoxc_backup_${var.project_name}"
  path = "/firefoxc/"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "firefoxc_backup_${var.project_name}"
  users      = [aws_iam_user.backup_user.name]
  policy_arn = aws_iam_policy.backup_user_policy.arn
}

resource "aws_iam_access_key" "backup_user_key" {
  user    = aws_iam_user.backup_user.name
}

resource "local_file" "credentials_csv" {
  content  = <<EOT
    User name,Access key ID,Secret access key
    firefoxc_backup_${var.project_name},${aws_iam_access_key.backup_user_key.id},${aws_iam_access_key.backup_user_key.secret}
    EOT
  filename = "credentials.csv"
}

resource "null_resource" "local_aws_profile_creds" {
  provisioner "local-exec" {
    command = <<EOT
      aws --profile firefoxc_backup_${var.project_name} configure set aws_access_key_id ${aws_iam_access_key.backup_user_key.id}
      aws --profile firefoxc_backup_${var.project_name} configure set aws_secret_access_key ${aws_iam_access_key.backup_user_key.secret}
      aws --profile firefoxc_backup_${var.project_name} configure set region ${var.aws_region}
    EOT
  }
}

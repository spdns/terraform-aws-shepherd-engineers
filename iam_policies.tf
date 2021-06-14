#
# Assume Role
#
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

#
# Shepherd Engineers
#

data "aws_iam_policy_document" "shepherd_engineers" {

  // Terraform State Lock
  statement {
    sid = "TerraformStateLockAccess"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    effect = "Allow"
    resources = [
      format("arn:%s:dynamodb:%s:%s:table/dds-shepherd-govcloud-terraform-state-lock",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
      data.aws_caller_identity.current.account_id),
    ]
  }

  // Allows shepherd engineers to access CreatePolicyVersion in IAM
  statement {
    effect = "Allow"
    actions = [
      "iam:*",
    ]
    resources = [
      format("arn:%s:iam::%s:group/*shepherd*", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id),
      format("arn:%s:iam::%s:role/*shepherd*", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id),
      format("arn:%s:iam::%s:policy/*shepherd*", data.aws_partition.current.partition, data.aws_caller_identity.current.account_id),
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  // Consolidated statement of all actions with wildcard resources for Shepherd Engineers.
  statement {
    effect = "Allow"
    actions = [
      "acm:*",
      "athena:*",
      "ec2:*",
      "glue:*",
      "iam:Get*",
      "iam:List*",
      "kms:ListAliases",
      "kms:Decrypt",
      "logs:*",
      "quicksight:*",
      "rds:*",
      "redshift:*",
      "ssm:*",
      "s3:*",
      "tag:*",
      "vpc:*",
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "shepherd_engineers" {
  name        = "app-${var.project}-${var.environment}-engineers"
  description = "Policy for 'shepherd_engineers' access"
  policy      = jsonencode(jsondecode(data.aws_iam_policy_document.shepherd_engineers.json))
}

resource "aws_iam_role_policy_attachment" "shepherd_engineers_policy_attachment" {
  role       = aws_iam_role.shepherd_engineers.name
  policy_arn = aws_iam_policy.shepherd_engineers.arn
}
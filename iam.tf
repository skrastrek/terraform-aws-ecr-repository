data "aws_iam_policy_document" "pull_image" {
  source_policy_documents = compact([
    try(data.aws_iam_policy_document.allow_pull_image_from_aws_account[0].json, ""),
    try(data.aws_iam_policy_document.allow_pull_image_from_organization[0].json, ""),
    try(data.aws_iam_policy_document.allow_pull_image_from_organization_path[0].json, ""),
  ])
}

data "aws_iam_policy_document" "allow_pull_image_from_aws_account" {
  count = length(var.resource_policy_pull_image_from_account_ids) != 0 ? 1 : 0

  statement {
    sid    = "PullImageFromAccount"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.resource_policy_pull_image_from_account_ids)
    }
  }
}

data "aws_iam_policy_document" "allow_pull_image_from_organization" {
  count = length(var.resource_policy_pull_image_from_organization_ids) != 0 ? 1 : 0

  statement {
    sid    = "PullImageFromOrganization"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = var.resource_policy_pull_image_from_organization_ids
    }
  }
}

data "aws_iam_policy_document" "allow_pull_image_from_organization_path" {
  count = length(var.resource_policy_pull_image_from_organization_paths) != 0 ? 1 : 0

  statement {
    sid    = "PullImageFromOrganizationPath"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = var.resource_policy_pull_image_from_organization_paths
    }
  }
}

module "pull_image_policy_document" {
  source  = "skrastrek/iam/aws//modules/policy-document/ecr-repository-pull"
  version = "1.2.1"

  ecr_repository_arn = aws_ecr_repository.this.arn
}

module "push_image_policy_document" {
  source  = "skrastrek/iam/aws//modules/policy-document/ecr-repository-push"
  version = "1.2.1"

  ecr_repository_arn = aws_ecr_repository.this.arn
}

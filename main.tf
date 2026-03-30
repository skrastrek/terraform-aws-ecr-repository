resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.id

  policy = templatefile("${path.module}/resources/ecr-lifecycle-policy.tpl", {
    keep_last_images_count = var.keep_last_images_count
  })
}

resource "aws_ecr_repository_policy" "this" {
  count = length(jsondecode(data.aws_iam_policy_document.pull_image.json).Statement) != 0 ? 1 : 0

  repository = aws_ecr_repository.this.id
  policy     = data.aws_iam_policy_document.pull_image.json
}

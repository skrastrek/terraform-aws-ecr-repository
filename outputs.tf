output "url" {
  value = aws_ecr_repository.this.repository_url
}

output "pull_image_iam_policy_document" {
  value = module.pull_image_policy_document.json
}

output "push_image_iam_policy_document" {
  value = module.push_image_policy_document.json
}

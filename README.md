# terraform-modules-aws-ecr-repository

Terraform module for creating an AWS ECR repository with lifecycle policies, repository access policies, and a managed IAM policy for pushing images.

## Features

- Creates an ECR repository with configurable image tag mutability and scan-on-push
- Attaches a lifecycle policy to retain only the last N images
- Optionally grants cross-account or cross-organization pull access via a repository policy
- Creates an IAM policy (for attachment to roles/users) that grants push access to the repository

## Usage

```hcl
module "ecr" {
  source = "github.com/your-org/terraform-modules-aws-ecr-repository"

  name                   = "my-app"
  keep_last_images_count = 10
  image_tag_mutability   = "IMMUTABLE"
  scan_on_push           = true

  resource_policy_pull_image_from_account_ids      = ["123456789012"]
  resource_policy_pull_image_from_organization_ids = []

  tags = {
    Environment = "production"
  }
}
```

## Variables

| Name | Type | Description |
|------|------|-------------|
| `name` | `string` | Name of the ECR repository |
| `keep_last_images_count` | `number` | Number of images to retain in the lifecycle policy |
| `image_tag_mutability` | `string` | Image tag mutability setting (`MUTABLE` or `IMMUTABLE`) |
| `scan_on_push` | `bool` | Whether to scan images for vulnerabilities on push |
| `resource_policy_pull_image_from_account_ids` | `list(string)` | AWS account IDs allowed to pull images |
| `resource_policy_pull_image_from_organization_ids` | `list(string)` | AWS Organizations IDs allowed to pull images |
| `tags` | `map(string)` | Tags to apply to all resources |

## Outputs

| Name | Description |
|------|-------------|
| `url` | The repository URL |
| `push_image_iam_policy_arn` | ARN of the IAM policy that grants push access |
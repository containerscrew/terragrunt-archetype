module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.0.6"

  repository_name                   = "lifullconnect/platform/test"
  repository_type                   = "private"
  repository_encryption_type        = "AES256"
  repository_read_write_access_arns = [data.aws_caller_identity.current.account_id]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}

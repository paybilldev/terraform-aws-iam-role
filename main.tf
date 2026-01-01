resource "aws_iam_role" "default" {
  name                 = var.role_name
  description          = var.role_description
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_aggregated[*].json)
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary
  path                 = var.path
  tags                 = var.tags
}

resource "aws_iam_policy" "default" {
  name        = var.policy_name
  description = var.policy_description
  policy      = join("", data.aws_iam_policy_document.default.*.json)
  path        = var.path
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = join("", aws_iam_role.default.*.name)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}

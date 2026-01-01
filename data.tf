################################################################################
## IAM Role
################################################################################
data "aws_iam_policy_document" "assume_role" {
  count = length(keys(var.principals)) > 0 ? length(keys(var.principals)) : 0
  statement {
    effect  = "Allow"
    actions = var.assume_role_actions

    principals {
      type        = element(keys(var.principals), count.index)
      identifiers = var.principals[element(keys(var.principals), count.index)]
    }

    dynamic "condition" {
      for_each = var.assume_role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "assume_role_aggregated" {
  override_policy_documents = data.aws_iam_policy_document.assume_role[*].json
}

data "aws_iam_policy_document" "default" {
  override_policy_documents = var.policy_documents
}


# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_role" {
   name = "role_lambda_${var.project_name}"

   assume_role_policy = templatefile("./policy_document_assume_lambda.tpl",{})
}

resource "aws_iam_policy" "policy" {
  name        = "policy_${var.project_name}"
  description = "Policy to ${var.project_name}"

  policy = templatefile("./policy_document_permission.tpl",{
    bucket_arn = aws_s3_bucket.bucket.arn
  })
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attachment_${var.project_name}"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.policy.arn
}
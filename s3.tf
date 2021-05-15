resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-bucket"
  acl    = "private"

}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_api.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = null
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
resource "aws_lambda_function" "lambda_api" {
    function_name = "${var.project_name}_add_face"
    memory_size = var.memory
    role          =  aws_iam_role.lambda_role.arn
    filename      = "./zips/main.zip"
    handler       = "main.handler"
    runtime       = "python3.8"
    timeout       = 60
    source_code_hash = data.archive_file.lambda_api.output_base64sha256
    layers        = [aws_lambda_layer_version.lambda_packages.arn]

    environment {
      variables = {
        CollectionID = "collection_teste"
        BucketName = aws_s3_bucket.bucket.id
      }
   }
}

data "archive_file" "lambda_api" {
  type        = "zip"
  source_file = "./app/main.py"
  output_path = "./zips/main.zip"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_api.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

# Define lambda permissions to grant API gateway, source arn is not needed
resource "aws_lambda_permission" "allow_api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_api.arn
  principal     = "apigateway.amazonaws.com"
}
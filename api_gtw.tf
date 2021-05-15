# As long as your lambda adheres to expected API Gateway format, this is all you'll need
# API Gateway
# Define the use of rest API
resource "aws_api_gateway_rest_api" "api" {
  name = var.project_name
  
  binary_media_types = ["multipart/form-data"]
}

# The resource for the endpoint
resource "aws_api_gateway_resource" "lambda" {
  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# How the gateway will be interacted from clientt
resource "aws_api_gateway_method" "lambda" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.lambda.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integration between lambda and terraform
resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.lambda.id
  http_method = aws_api_gateway_method.lambda.http_method
  # Lambda invokes requires a POST method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_api.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_method.lambda,
    aws_api_gateway_integration.integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "default"
}

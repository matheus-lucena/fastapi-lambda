resource "aws_lambda_layer_version" "lambda_packages" {
  filename   = "./zips/packages.zip"
  layer_name = "packages"
  source_code_hash = data.archive_file.packages.output_base64sha256
  compatible_runtimes = ["python3.8"] 
}

data "archive_file" "packages" {
  type        = "zip"
  source_dir = "./packages"
  output_path = "./zips/packages.zip"
}
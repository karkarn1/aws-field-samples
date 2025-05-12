locals {
  lambda_layer_zip_path = "${path.module}/build/lambda_layers/python_dependencies_layer.zip"
}

resource "null_resource" "build_lambda_layer" {
  triggers = {
    build_script_hash = filemd5("${path.module}/scripts/build_lambda_layer.sh")
    zip_file_exists   = fileexists(local.lambda_layer_zip_path)
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/build_lambda_layer.sh"
  }
}

# Lambda Layer resource
resource "aws_lambda_layer_version" "opensearch_layer" {
  layer_name          = "${var.name}-dependencies"
  description         = "Contains general purpose python packages"
  filename            = local.lambda_layer_zip_path
  compatible_runtimes = ["python3.13"]

  depends_on = [null_resource.build_lambda_layer]
}

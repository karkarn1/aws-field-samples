resource "null_resource" "this" {
  triggers = {
    env = var.env
  }
}

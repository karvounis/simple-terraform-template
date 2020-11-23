resource "aws_iam_user" "hello_world" {
  name                 = "hello-world"
  path                 = "/"
  tags                 = {}
  permissions_boundary = null
}

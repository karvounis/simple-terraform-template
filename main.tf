resource "aws_iam_user" "hello_world" {
  name                 = "hello-world"
  path                 = "/"
  tags                 = {}
  permissions_boundary = null
}

resource "aws_instance" "foo" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t1.2xlarge" # invalid type!
}

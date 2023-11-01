provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "web" {
  ami = "ami-086cae3329a3f7d75"
  instance_type = "t3.micro"

  tags = {
    Name = "Hello State!"
  }
}
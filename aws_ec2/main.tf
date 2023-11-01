provider "aws" {
  region = "ap-northeast-2"
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }

# resource "aws_instance" "web" {
#   ami = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"

#   tags = {
#     Name = "Hello World"
#   }
# }

resource "aws_instance" "name" {
  ami = "ami-086cae3329a3f7d75"
  instance_type = "t3.micro"

  tags = {
    Name = "Hello word"
  }
}
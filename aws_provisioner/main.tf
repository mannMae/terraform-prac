provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "web" {
  ami = "ami-0bcb37eab443e2f5b"
  instance_type = "t3.micro"

  tags = {
    Name = "Hello word"
  }

  key_name = aws_key_pair.web.id

  provisioner "remote-exec" {
      inline = [
          "sudo yum update",
          "sudo yum install nginx -y",
          "sudo service nginx start",
          "sudo chkconfig nginx on"
      ]
  }

  connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file("/Users/gimjaeman/.ssh/id_rsa")
  }

  provisioner "local-exec" {
    on_failure = fail
    command = "echo ${aws_instance.web.public_ip} >> /tmp/public_ip.txt"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -f /tmp/public_ip.txt"
  }

  vpc_security_group_ids = [aws_security_group.ssh-access.id, aws_security_group.nginx-access.id]
}

resource "aws_key_pair" "web" {
  public_key = file("/Users/gimjaeman/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "nginx-access" {
  name = "nginx-access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "publicip" {
  value = aws_instance.web.public_ip
}
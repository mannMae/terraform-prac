resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits = 4096
}

variable "key_name" {
  type = string
  default = "awslearner_keypair"
  description = "pem file"
}

resource "aws_key_pair" "key_pair" {
  key_name = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_launch_template" "web_launch_template" {
  name = "web-launch-template"
  image_id = "ami-086cae3329a3f7d75"
  instance_type = "t2.micro"

  key_name = aws_key_pair.key_pair.key_name

  # user_data = filebase64("${path.module}/server.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.goormVPC_security_group.id]
  }
}

resource "aws_autoscaling_group" "web_autoscaling_group" {
  name = "web-autoscaling-group"
  min_size = 2
  max_size = 3
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.web_lb_target_group.arn]
  vpc_zone_identifier = [aws_subnet.public_web_a.id, aws_subnet.public_web_c.id]

  launch_template {
    id = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "app_launch_template" {
  name = "app-launch-template"
  image_id = "ami-086cae3329a3f7d75"
  instance_type = "t2.micro"

  key_name = aws_key_pair.key_pair.key_name

  # user_data = filebase64("${path.module}/server.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.goormVPC_security_group.id]
  }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  name = "app-autoscaling-group"
  min_size = 2
  max_size = 3
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.app_lb_target_group.arn]
  vpc_zone_identifier = [aws_subnet.private_app_a.id, aws_subnet.private_app_c.id]

  launch_template {
    id = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
}
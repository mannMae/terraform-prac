resource "aws_lb" "web_lb" {
  name = "web-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.goormVPC_security_group.id]
  subnets = [aws_subnet.public_web_a.id, aws_subnet.public_web_c.id]
}

resource "aws_lb_target_group" "web_lb_target_group" {
  name = "web-lb-target-group"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.goormVPC.id
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target_group.arn
  }
}

resource "aws_lb" "app_lb" {
  name = "app-lb"
  internal = true
  load_balancer_type = "application"
  security_groups = [aws_security_group.goormVPC_security_group.id]
  subnets = [aws_subnet.private_app_a.id, aws_subnet.private_app_c.id]
}

resource "aws_lb_target_group" "app_lb_target_group" {
  name = "app-lb-target-group"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.goormVPC.id
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}
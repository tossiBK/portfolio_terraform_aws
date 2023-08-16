# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-create-load-balancer-console.html


resource "aws_lb" "lb" {
  name               = "loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer.id]
  subnets            = [aws_subnet.sub_region_az_1.id, aws_subnet.sub_region_az_2.id]
}


resource "aws_lb_target_group" "lb_target_group" {
  name     = "lbtarget"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_region.id
  
  health_check {
    enabled  = true
    port     = 80
    protocol = "HTTP"
    path     = "/index.html"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_listener" "lb_listener_web" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}




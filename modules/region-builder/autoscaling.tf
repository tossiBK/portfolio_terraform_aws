# https://registry.terraform.io/providers/hashicorp/aws/4.44.0/docs/resources/autoscaling_group.html
# https://registry.terraform.io/providers/-/aws/latest/docs/resources/autoscaling_attachment


# https://docs.aws.amazon.com/autoscaling/ec2/userguide/attach-load-balancer-asg.html
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/tutorial-ec2-auto-scaling-load-balancer.html

resource "aws_autoscaling_group" "server_instances" {
  name = "autoscale-group"
  min_size           = var.scale_min
  max_size           = var.scale_max
  desired_capacity   = var.scale_target
  default_cooldown   = 300
  health_check_grace_period = 300
  vpc_zone_identifier  = [aws_subnet.sub_region_az_1.id, aws_subnet.sub_region_az_2.id]
  target_group_arns    = [aws_lb_target_group.lb_target_group.arn]

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.min_health
    }
  }

  launch_template {
    id      = aws_launch_template.webserver_image.id
    version = aws_launch_template.webserver_image.latest_version
  }
}


resource "aws_autoscaling_policy" "cpu_scale" {
  autoscaling_group_name = aws_autoscaling_group.server_instances.name
  name                   = "cpu-scaling"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_max
  }
}


# grouping to load balancer

resource "aws_autoscaling_attachment" "webserver_balancer" {
  autoscaling_group_name = aws_autoscaling_group.server_instances.id
  lb_target_group_arn    = aws_lb_target_group.lb_target_group.arn
}
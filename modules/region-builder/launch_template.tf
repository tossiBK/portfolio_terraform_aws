# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami.html
data "aws_ami" "amazon" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-asg-launch-template.html#limitations

resource "aws_launch_template" "webserver_image" {
  name = "webserver_image"
  key_name = "cloud_programming_keypair"

  image_id = data.aws_ami.amazon.image_id
  instance_type = var.instance_type

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.allow_web_ssh.id]
  }


  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  
  user_data = filebase64("${path.module}/user-data-az.sh")
}
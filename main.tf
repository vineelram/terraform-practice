terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "Web app port to expose"
  type = number
  default = 8080
}

resource "aws_instance" "app-ec2" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    tags = {
      Name = "app-ec2"
    }
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, world" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    user_data_replace_on_change = true
    vpc_security_group_ids = [ aws_security_group.app-sg.id ]
}

resource "aws_security_group" "app-sg" {
    description = "Security group for web app"
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp" 
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    name = "webapp-sg"
    revoke_rules_on_delete = true
}

output "public_ip" {
  value       = aws_instance.app-ec2.public_ip
  description = "The public IP address of the web server"
}

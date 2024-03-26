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

resource "aws_instance" "app-ec2" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    tags = {
      Name = "app-ec2"
    }
}

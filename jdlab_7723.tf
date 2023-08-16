terraform {
  backend "local" {
  }
  required_version = ">=0.13"
}

provider "aws" {
  # profile = "my_aws_creds"
  region = "eu-west-2"
}

#########################################################
# Security Group
#########################################################
resource "aws_security_group" "prod_servers_sg" {
  name        = "prod_servers_sg"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }

}

#########################################################
# EC2 Instances
#########################################################

resource "aws_instance" "prod_web" {
  ami           = "ami-0f3d9639a5674d559"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod_servers_sg.id
  ]

  tags = {
    "Terraform" = "true"
    "Name"      = "prod_web"
  }


  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "required"
  }
}

resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform" = "true"
    "Name"      = "prod_web_eip"
  }
}

resource "aws_instance" "prod_suse_server001" {
  ami           = "ami-0c85fbc58274d979c"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod_servers_sg.id
  ]

  tags = {
    "Terraform" = "true"
    "Name"      = "prod_suse_server001"
  }


  metadata_options {
    http_endpoint = "disabled"
    http_tokens   = "required"
  }
}

resource "aws_eip" "prod_suse_server001" {
  instance = aws_instance.prod_suse_server001.id

  tags = {
    "Terraform" = "true"
    "Name"      = "prod_suse_server001_eip"
  }
}

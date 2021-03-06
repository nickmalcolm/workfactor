provider "aws" {
  region        = var.aws_region
  profile       = var.aws_profile
}

# Create a security group where only a single IP
# has SSH access, but the instance has full egress
resource "aws_security_group" "workfactor_sg" {
  name = "workfactor-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.your_ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a brand-new private/public keypair

# IMPORTANT SECURITY NOTE
# The private key generated by this resource will be stored
# unencrypted in your Terraform state file. 
resource "tls_private_key" "workfactor_keypair" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}
resource "aws_key_pair" "workfactor_key" {
  key_name   = "workfactor-key"
  public_key = tls_private_key.workfactor_keypair.public_key_openssh
}

# Dynamically identify the latest ECS-optimised AMI
# which comes pre-installed with Docker
data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS Owner

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  } 
}

# Create an instance with the security group, AMI, and SSH keypair
resource "aws_instance" "workfactor_instance" {
  ami           = data.aws_ami.latest_ecs.id
  instance_type = var.instance_type
  key_name = aws_key_pair.workfactor_key.key_name
  vpc_security_group_ids = [aws_security_group.workfactor_sg.id]
  tags = {
    Name = "workfactor"
  }
}

# Create a public ECR repository for pushing each Docker container into
# Public repos are free
# TODO: Wait for this to be released in Terraform
# https://github.com/hashicorp/terraform-provider-aws/issues/16540
# resource "aws_ecrpublic_repository_policy" "workfactor_ecr_repo_ruby_bcrypt" {
#   name                 = "workfactor/ruby-bcrypt"
#   image_tag_mutability = "MUTABLE"
# }

output "workfactor_instance_ip" {
  value = aws_instance.workfactor_instance.public_ip
}

output "workfactor_private_key" {
  value = tls_private_key.workfactor_keypair.private_key_pem
}
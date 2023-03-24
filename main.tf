data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev"
  cidr = "192.168.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["192.168.101.0/24", "192.168.102.0/24", "192.168.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "blog" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.blog_sg.security_group_id]
  tags = {
    Name = "Learning Terraform"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name    = "blog"
  
  vpc_id = module.vpc.vpc_id
  
  ingress_rules       = ["http-80-tcp","https-443-tcp","all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]  
}

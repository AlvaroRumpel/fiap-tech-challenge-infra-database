provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "fiap-tech-challenge-infra-db"
}

resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-2a"

  tags = {
    Name = "Default subnet for us-east-2a"
  }
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-2b"

  tags = {
    Name = "Default subnet for us-east-2b"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db" {  

  storage_type           = "gp2"
  engine                 = "mysql"
  db_name                = "db"
  identifier             = "db"
  instance_class         = "db.m5d.large"
  allocated_storage      = 10
  publicly_accessible    = true
  username               = "dbuser"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot    = true

  tags = {
    Name = "db"
  }

}




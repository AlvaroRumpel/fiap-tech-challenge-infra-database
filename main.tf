provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "fiap-tech-challenge-infra-db"
}

resource "aws_security_group" "db" {
  name_prefix = "db-"
  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db" {  

  storage_type           = "gp2"
  engine                 = "mysql"
  db_name                = "db"
  identifier             = "db"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username             = "dbuser"
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true

  tags = {
    Name = "db"
  }
}

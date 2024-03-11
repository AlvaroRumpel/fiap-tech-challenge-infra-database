provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "fiap-tech-challenge-infra-db"
}

resource "aws_db_instance" "db" {  

  allocated_storage      = 5
  storage_type           = "gp2"
  engine                 = "mysql"
  db_name                = "db"
  identifier             = "db"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username             = "dbuser"
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "db"
  }
}

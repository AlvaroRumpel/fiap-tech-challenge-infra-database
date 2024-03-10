provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "fiap-tech-challenge-infra-db"
}

resource "aws_db_instance" "db" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "db"
  username             = "dbuser"
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  skip_final_snapshot     = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet"
  subnet_ids = [length(data.aws_subnet.existing_subnet_a.ids) > 0 ? data.aws_subnet.existing_subnet_a[0].id : aws_subnet.subnet_a.id, length(data.aws_subnet.existing_subnet_b.ids) > 0 ? data.aws_subnet.existing_subnet_b[0].id : aws_subnet.subnet_b.id]

  tags = {
    Name = "DB Subnet Group"
  }
}

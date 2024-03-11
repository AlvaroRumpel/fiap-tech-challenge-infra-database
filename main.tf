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

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = "true"
  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "rds_public_subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "rds_public_subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "rds_private_subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "rds_private_subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_db_subnet_group" "rdssubnet" {
  name       = "database subnet"
  subnet_ids = ["${aws_subnet.rds_private_subnet_a.id}","${aws_subnet.rds_private_subnet_b.id}"]
}

resource "aws_eip" "nat" { 
  vpc = true

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_internet_gateway" "igw" { 
  vpc_id     = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gw" { 
  allocation_id     = aws_eip.nat.id
  subnet_id = aws_subnet.rds_private_subnet_a.id

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "router" { 
  vpc_id     = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  } 
}

resource "aws_route_table_association" "assoc" { 
  subnet_id = aws_subnet.rds_private_subnet_a.id
  route_table_id = aws_route_table.router.id
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
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
  allocated_storage      = 10
  publicly_accessible    = true
  username               = "dbuser"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rdssubnet.name

  skip_final_snapshot    = true

  tags = {
    Name = "db"
  }

}




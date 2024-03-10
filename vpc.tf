data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["rds-vpc"]
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = data.aws_vpc.existing_vpc.id != null ? data.aws_vpc.existing_vpc.id : aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = data.aws_vpc.existing_vpc.id != null ? data.aws_vpc.existing_vpc.id : aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = data.aws_vpc.existing_vpc.id != null ? data.aws_vpc.existing_vpc.id : aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


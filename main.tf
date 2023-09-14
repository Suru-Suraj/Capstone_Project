resource "aws_vpc" "CAPSTONE" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "CAPSTONE"
  }
}
resource "aws_subnet" "PUBLIC-1" {
  vpc_id     = aws_vpc.CAPSTONE.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PUBLIC-1"
  }
}
resource "aws_subnet" "PUBLIC-2" {
  vpc_id     = aws_vpc.CAPSTONE.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "PUBLIC-2"
  }
}
resource "aws_subnet" "PRIVATE" {
  vpc_id     = aws_vpc.CAPSTONE.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "PRIVATE"
  }
}
resource "aws_route_table" "PUBLIC" {
  vpc_id = aws_vpc.CAPSTONE.id
  tags = {
    Name = "PUBLIC"
  }
}
resource "aws_route_table" "PRIVATE" {
  vpc_id = aws_vpc.CAPSTONE.id
  tags = {
    Name = "PRIVATE"
  }
}
resource "aws_route_table_association" "PUBLIC-1" {
  subnet_id      = aws_subnet.PUBLIC-1.id
  route_table_id = aws_route_table.PUBLIC.id
}
resource "aws_route_table_association" "PUBLIC-2" {
  subnet_id      = aws_subnet.PUBLIC-2.id
  route_table_id = aws_route_table.PUBLIC.id
}
resource "aws_route_table_association" "PRIVATE" {
  subnet_id      = aws_subnet.PRIVATE.id
  route_table_id = aws_route_table.PRIVATE.id
}
resource "aws_internet_gateway" "CAPSTONE" {
  vpc_id = aws_vpc.CAPSTONE.id
  tags = {
    Name = "CAPSTONE"
  }
}
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.PUBLIC.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.CAPSTONE.id
}

resource "aws_eip" "CAPSTONE" {
  domain   = "vpc"
  tags = {
    Name = "CAPSTONE"
  }
}
resource "aws_nat_gateway" "CAPSTONE" {
  allocation_id = aws_eip.CAPSTONE.id
  subnet_id     = aws_subnet.PUBLIC-1.id
  tags = {
    Name = "CAPSTONE"
  }
}
resource "aws_route" "r" {
  route_table_id  = aws_route_table.PRIVATE.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.CAPSTONE.id
}

resource "aws_security_group" "CAPSTONE" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.CAPSTONE.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "CAPSTONE"
  }
}
resource "aws_instance" "CAPSTONE-PUBLIC" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  subnet_id = aws_subnet.PUBLIC-1.id
  key_name = "suru"
  tags = {
    Name = "CAPSTONE-PUBLIC"
  }
}
resource "aws_instance" "CAPSTONE-PRIVATE" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  subnet_id = aws_subnet.PRIVATE.id
  key_name = "suru"
  tags = {
    Name = "CAPSTONE-PRIVATE"
  }
}
output "public_private_ip" {
  value = aws_instance.CAPSTONE-PUBLIC.private_ip
}

output "public_public_ip" {
  value = aws_instance.CAPSTONE-PUBLIC.public_ip
}

output "private_private_ip" {
  value = aws_instance.CAPSTONE-PRIVATE.private_ip
}


resource "aws_launch_template" "CAPSTONE" {
  name = "CAPSTONE"
  image_id = "ami-06a0a61d43cf06546"
  instance_type = "t2.micro"
  key_name = "suru"
  vpc_security_group_ids = aws_security_group.CAPSTONE.id
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }
}

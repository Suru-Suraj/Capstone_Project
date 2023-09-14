resource "aws_vpc" "CAPSTONE" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "CAPSTONE"
  }
}

resource "aws_subnet" "PUBLIC" {
  vpc_id     = aws_vpc.CAPSTONE.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PUBLIC-1"
  }
}

resource "aws_route_table" "PUBLIC" {
  vpc_id = aws_vpc.CAPSTONE.id
  tags = {
    Name = "PUBLIC"
  }
}

resource "aws_route_table_association" "PUBLIC" {
  subnet_id      = aws_subnet.PUBLIC.id
  route_table_id = aws_route_table.PUBLIC.id
}

resource "aws_internet_gateway" "CAPSTONE" {
  vpc_id = aws_vpc.CAPSTONE.id
  tags = {
    Name = "CAPSTONE"
  }
}

resource "aws_route" "CAPSTONE" {
  route_table_id         = aws_route_table.PUBLIC.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.CAPSTONE.id
}

resource "aws_security_group" "CAPSTONE" {
  name        = "CAPSTONE"
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
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Custom port 3000 from VPC"
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

resource "aws_key_pair" "capstone" {
  key_name   = "capstone"
  public_key = tls_private_key.capstone.public_key_openssh
}
resource "tls_private_key" "capstone" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "capstone" {
  content  = tls_private_key.capstone.private_key_pem
  filename = "capstone.pem"
}

resource "aws_instance" "CAPSTONE" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  subnet_id = aws_subnet.PUBLIC.id
  key_name = "capstone"
  tags = {
    Name = "CAPSTONE-PUBLIC"
  }
}

output "private_ip" {
  value = aws_instance.CAPSTONE.private_ip
}

output "public_ip" {
  value = aws_instance.CAPSTONE.public_ip
}
output "instance_id" {
  description = "Instance ID of the EC2 instance"
  value       = aws_instance.CAPSTONE.id
}
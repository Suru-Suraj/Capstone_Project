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
  vpc      = true
  domain = "vpc"
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

resource "aws_route" "CAPSTONE" {
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

resource "aws_instance" "CAPSTONE-PUBLIC" {
  ami           = "ami-06a0a61d43cf06546"
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
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }
}

resource "aws_lb_target_group" "CAPSTONE" {
  name     = "CAPSTONE"
  port     = 3000
  protocol = "TCP"
  vpc_id   = aws_vpc.CAPSTONE.id
}

resource "aws_lb_target_group_attachment" "CAPSTONE" {
  target_group_arn = aws_lb_target_group.CAPSTONE.arn
  target_id        = aws_instance.CAPSTONE-PUBLIC.id
  port             = 3000
}

resource "aws_s3_bucket" "capstone764001" {
  bucket = "capstone764001"
  permissions = FULL_CONTROL

  tags = {
    Name        = "CAPSTONE"
    Environment = "production"
  }
}

resource "aws_elb" "CAPSTONE" {
  name               = "CAPSTONE"
  internal           = false
  subnets = [aws_subnet.PUBLIC-1.id, aws_subnet.PUBLIC-2.id]
  access_logs {
    bucket        = aws_s3_bucket.capstone764001.bucket
    bucket_prefix = "capstone764001"
    interval      = 60
  }
  security_groups = [aws_security_group.CAPSTONE.id]
  listener {
    instance_port     = 3000
    instance_protocol = "tcp"
    lb_port           = 3000
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3000"
    interval            = 30
  }

  instances                   = [aws_instance.CAPSTONE-PUBLIC.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "CAPSTONE"
  }
}

output "lb_dns_name" {
  value = aws_elb.CAPSTONE.dns_name
}

resource "aws_autoscaling_group" "CAPSTONE" {
  availability_zones = ["us-east-1a","us-east-1b"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.CAPSTONE.id
    version = "$Latest"
  }
}

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
resource "aws_key_pair" "CAPSTONE" {
  key_name = "CAPSTONE"
  public_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAi57NfYZUEVHZ2jFQBrQaQk9MY4tOdqIdkrqil/sgNmrprdja
DDsDjLO2JjIHQbQMX1mcPIsclti6jOhRr3+xgTHHBYfDZzjAXJ1+NpaUo2eNyt8K
W7znIn8G4PcbBwawnjsR8KJ3J0c5en/caDOgCQ0/68lp363nM7oSrFOgJtlR5XEG
2ra8pZXfLnua7Ne1GVE/PbCKnxt/JaQJP8tEt45ID44QMEe5xe7VC2yc3l8AmkZf
rZKICJrNu9zZo+HGNUl2vB3JnRIhUj7eCbu79tD84uYkR1Iiko7IuLFqjKxEnn/l
aT97752AwGggrrkqxfDGP6FmpA5AP9h6N4CyVQIDAQABAoIBAH9DCFraDdabnM7d
E+yITUcTsLUrTSGlMv+DTqDpLbtsSANGHbn4MIwXYnf+Mc8Zpg1jSJ2Gz1BPy/qT
56Dn64uvK5FG5j035V6Fz31CU8l9oijAlFh6HtO6pTJ5ChGlb2dKwFduPt12dlXK
JcR1CfI2OYVZ2T8g7BSiDlM1Bk1hdZyKp1XHs1+6r0oxblrX+6MGRDIn1BmKgLUN
3+58S+AqSsCvbjE1q05gVCXci5JUDYVNQBhvjTApnpdJAz6FkhmEdIJcl+aeXCe3
YkduRuExMLbN1zYU/lT0V91ZiYdl75W/T7aXJWnJKxAcqTWAvaft8VqNmhzlrOlO
XK+5aiECgYEA8h2GecDBEHZtCkBJk4g0X/Vn8WhVU+pwcYyQIdQpPzMoqTvFW/le
vSMKS2hJffqij+gSDy2fu/S/lUlMind7dq3j3/skV/BQbluMH/epS8lwWDwoOd+V
rx8isS4fj6xiebYnKTMptboRP+C2lnmUuT7Kkjb8XeMjpUehMVXUpRcCgYEAk6CO
jNNFEd+g5jBTlzsyEGwAuTWteAunNCKhyOxRTnRtqimfSyF3R/nA1kUpSSHt4O/N
GI7US2A/IUR8ym1UlURPEpflr8i0qMFWPDUKHUfGqivOEm6thLjEhkWeRUpMGBDF
vEnww7PSlXKIqt8DGw9yngEJvbqksTCrAJ5hX3MCgYAvcFuN9ZeeiyW4UXpZHuHs
P2Bba670X0Yi6YDAMBrY2ERKTHzSFZ1bf8cfmVJ1DavWeIk5Uh4vLLhxHsiRhPG7
Aj1ZAJNRa7PGu8dL6DHSuKh7kWXsWQOyKW6ZusjSVNuCr48iwnSUt91zX6tG9pGO
bmAwn/d4ye2ND+jkisW8hwKBgQCG1SD9bETsYzSgqUjfmnhKWWp7vpP2TaZkTrE3
Quer4Vj8DtHnm+RG/8xpp3dizTNnu322TVWGlpxyNQxJEnwrbN1PnR5yY7zlWNf7
W3ImdhTz/dhUK3QeAWe1P0akAIzpegAvzdSx2b6fMqGydsduYriLqWUNPbgIAexd
P0quEwKBgBx7V65yiTedg0wq73AefQ/ty9agbImB48epk75eYswt1o+2ip+TjGcV
fQOs07Bu3CDEt3yEkIzGyNbhhEquqhyNf+OG8FA/M2WG49hf1MjmNY0qE0Ws9afk
tp/DlBVcINunMrogQEXc0fEXBsHLR5VKNzlLAHPc/Zh5GaBbv6gP
-----END RSA PRIVATE KEY-----"
}
resource "aws_instance" "CAPSTONE-PUBLIC" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  subnet_id = aws_subnet.PUBLIC-1.id
  key_name = aws_key_pair.CAPSTONE.key_name
  tags = {
    Name = "CAPSTONE-PUBLIC"
  }
}
resource "aws_instance" "CAPSTONE-PRIVATE" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CAPSTONE.id]
  subnet_id = aws_subnet.PRIVATE.id
  key_name = aws_key_pair.CAPSTONE.key_name
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

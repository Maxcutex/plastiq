resource "aws_security_group" "first_vpc_alb-security-group" {
  name        = "ALB Security Group VPC1"
  description = "Enable HTTP/HTTPS access on Port 80/443 on first VPC"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ALB Security Group VPC1"
  }
}

resource "aws_security_group" "first_vpc_ssh-security-group" {
  name        = "SSH Security Group VPC1"
  description = "Enable SSH access on Port 22 on first VPC"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description      = "SSH Access on VPC1"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh-location}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "SSH Security Group VPC1"
  }
}

resource "aws_security_group" "webserver-security-group" {
  name        = "Web Server Security Group VPC1"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.first_vpc_alb-security-group.id}"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.first_vpc_alb-security-group.id}"]
  }

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.first_vpc_ssh-security-group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Web Server Security Group"
  }
}

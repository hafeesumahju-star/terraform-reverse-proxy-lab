resource "aws_security_group" "proxy_sg" {
  name        = "rp-proxy-sg"
  description = "Reverse proxy SG"
  vpc_id      = aws_vpc.rp_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rp-proxy-sg"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "rp-backend-sg"
  description = "Backend SG, allow HTTP only from proxy"
  vpc_id      = aws_vpc.rp_vpc.id

  ingress {
    description     = "HTTP from proxy"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rp-backend-sg"
  }
}

resource "aws_security_group" "ssm_endpoints_sg" {
  name        = "ssm-endpoints-sg"
  description = "Allow HTTPS from VPC to SSM endpoints"
  vpc_id      = aws_vpc.rp_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rp-ssm-endpoints-sg"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.rp_vpc.id
  service_name      = "com.amazonaws.ap-south-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]

  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "rp-ssm-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.rp_vpc.id
  service_name      = "com.amazonaws.ap-south-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]

  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "rp-ssmmessages-endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.rp_vpc.id
  service_name      = "com.amazonaws.ap-south-1.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]

  security_group_ids  = [aws_security_group.ssm_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "rp-ec2messages-endpoint"
  }
}

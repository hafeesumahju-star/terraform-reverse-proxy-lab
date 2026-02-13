########################
# Backend 1 (public subnet, internet access)
########################

resource "aws_instance" "backend1" {
  ami                         = "ami-03f4878755434977f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<html><h1>Backend 1</h1></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "rp-backend-1"
  }
}

########################
# Backend 2 (private subnet)
########################

resource "aws_instance" "backend2" {
  ami                         = "ami-03f4878755434977f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<html><h1>Backend 2</h1></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "rp-backend-2"
  }
}

########################
# Proxy (public subnet, reverse proxy to backends)
########################

resource "aws_instance" "proxy" {
  ami                         = "ami-03f4878755434977f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.proxy_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx

              cat > /etc/nginx/sites-available/reverse-proxy << 'NGINXCONF'
              upstream backend_servers {
                  server ${aws_instance.backend1.private_ip}:80;
                  server ${aws_instance.backend2.private_ip}:80;
              }

              server {
                  listen 80;
                  server_name _;

                  location / {
                      proxy_pass http://backend_servers;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }
              NGINXCONF

              rm -f /etc/nginx/sites-enabled/default
              ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy

              systemctl restart nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "rp-proxy"
  }

  depends_on = [
    aws_instance.backend1,
    aws_instance.backend2
  ]
}

# Terraform Reverse Proxy Lab (AWS + Nginx)

This lab deploys a simple reverse proxy architecture on AWS using Terraform and Nginx.

## Architecture

- **VPC** with public and private subnets (Mumbai / ap-south-1).
- **Proxy EC2 (rp-proxy)**  
  - Public subnet, public IP (e.g. `65.2.137.151`).  
  - Nginx installed via `user_data`.  
  - Acts as a reverse proxy and single public entry point.
- **Backend1 EC2 (rp-backend-1)**  
  - In VPC, reached via private IP (e.g. `10.1.1.253`).  
  - Nginx serves a simple HTML page.  
  - Proxy forwards traffic to this private IP.
- **Backend2 EC2 (rp-backend-2)**  
  - In private subnet, currently without internet/NAT in this lab.  
  - Reserved for future NAT + load balancing extension.

## Nginx reverse proxy

Proxy config (`/etc/nginx/sites-available/reverse-proxy`):

```nginx
upstream backend_servers {
    server 10.1.1.253:80;
    # server 10.1.3.159:80; # backend2 for future NAT lab
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

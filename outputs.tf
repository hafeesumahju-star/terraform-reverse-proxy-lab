output "proxy_public_ip" {
  value = aws_instance.proxy.public_ip
}

output "backend1_private_ip" {
  value = aws_instance.backend1.private_ip
}

output "backend2_private_ip" {
  value = aws_instance.backend2.private_ip
}

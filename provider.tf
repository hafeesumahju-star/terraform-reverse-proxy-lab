terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = "ap-south-1"
  # TEMP: force parse of networking.tf
  # locals {
  #   vpc_id_check = aws_vpc.rp_vpc.id
  # }

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "exp" {
  count                       = 5
  ami                         = "ami-0767046d1677be5a0"
  instance_type               = "t2.micro"
  key_name                    = "uber"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0e753b2bf658155d5"]
  monitoring                  = true
  user_data                   = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
curl https://get.docker.com/ > ~/docker.sh
sudo chmod 777 ~/docker.sh
cd ~
./docker.sh
EOF

  tags = {
    Name = "swarm server${count.index}"
  }
}

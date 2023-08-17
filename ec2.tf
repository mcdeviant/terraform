provider "aws" {
  region = "ap-southeast-2"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-0a709bebf4fa9246f"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.allow_tls.id,
aws_security_group.allow_http.id]
  iam_instance_profile = aws_iam_instance_profile.leemacprofile.name

  tags = {
    Name = random_pet.name.id
    env = "tag"
  }
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-#####"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["CIDRBLOCK/##"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_security_group" "allow_http"{
  name        = "allow_http"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = "vpc-######"

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["mystaticip/32"]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow http"
  }
}
resource "aws_iam_role" "leemacrole" {
  name = "lees_role"
  description = "Testing creating and attaching resources to EC2 hosts"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action= "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
         }
       }
     ]
  })
}

resource "aws_iam_instance_profile" "leemacprofile" {
  name = "leemacprofile"
  role = aws_iam_role.leemacrole.name
}
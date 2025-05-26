resource "aws_instance" "Lee_lab01" {
    ami           = "ami-0267c89e9febf1ac0"
    instance_type = "t2.micro"
    subnet_id = "subnet-0fdb4a7251f10ed36"
    tags = {
        Name        = var.name_tag
        owner       = "lee.macdonald"
        costgroup   = "digital"
        env         = "test"
        }
    }
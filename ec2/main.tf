data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

resource "aws_instance" "ec2" {
  ami                    = "ami-0a017d8ceb274537d"
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = var.component
  }
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      user = "centos"
      password = "DevOps321"
    }
    inline = [
    "git clone https://github.com/srini123k/roboshop-shell",
      "cd roboshop-shell",
      "sudo bash ${var.component}.sh"
    ]
  }
}
resource "aws_security_group" "sg" {
  name        = "${var.component}-${var.env}-sg"
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}

resource "aws_route53_record" "record" {
  zone_id = "Z0552687ZOEXRFHA1XPG"
  name    = "${var.component}-dev.devopsb71.cloud"
  type    = "A"
  ttl     = 300
  records = [var.private_ip]
}

#output "sg_id" {
 # value = aws_security_group.allow_tls.id
#}

variable "component" {}

variable "instance_type" {}

#variable "sg_id" {}

variable "env" {}
 default="dev"

#output "private_ip" {
 # value = aws_instance.ec2.private_ip
#}
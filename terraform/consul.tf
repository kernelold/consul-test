provider "aws" {
  region     = "eu-west-1"
}

variable "zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

resource "aws_security_group" "allow_22" {
  name        = "allow_22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "egress" {
  name        = "egress"
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_consul" {
  name        = "allow_consul"

  ingress {
    from_port   = 8300
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8301
    to_port     = 830
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8600 
    to_port     = 8600 
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8600 
    to_port     = 8600 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "consul" {
  count                  = 3
  private_dns            = "cousulvm${count.index}"
  name                   = "cousulvm${count.index}"
#  ami                    = "ami-08660f1c6fb6b01e7"
  ami                    = "ami-08eb05c142193af92"
  instance_type          = "t1.micro"
  key_name               = "consul-key"
  user_data              = "${file("userdata.sh")}"
  vpc_security_group_ids = ["${aws_security_group.allow_22.id}","${aws_security_group.allow_consul.id}","${aws_security_group.egress.id}"]
  availability_zone      = "${var.zones[count.index]}"
}

output "instance_ips" {
  value = ["${aws_instance.consul.*.public_ip}"]
}




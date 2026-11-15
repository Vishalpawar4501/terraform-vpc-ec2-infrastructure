# key pair (login)
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}
# vpc & security group
resource "aws_default_vpc" "default" {}


resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a TF generated security group"
  vpc_id      = aws_default_vpc.default.id # interpolation
               

  # inbound rule

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh access from anywhere"
  }
   
  ingress {
    from_port = 80
    to_port  = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "flask app access from anywhere"
  }

  # outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }
  tags = {
    Name = "automate-sg"
  }
}
# ec2 instance 

resource "aws_instance" "my_instance" {
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  instance_type   = var.ec2_instance_type
  ami             = var.ec2_ami_id  # ubuntu
  user_data       = file("install_nginx.sh") # script to install nginx server



  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = "vishal-junoon-automation"
  }
}
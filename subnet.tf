resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_default_vpc.default.id # Apne VPC ka exact naam check karein
  cidr_block              = "172.31.96.0/20"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}
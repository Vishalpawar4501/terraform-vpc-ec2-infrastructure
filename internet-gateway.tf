resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id   # use your actual VPC resource name

  tags = {
    Name = "main-igw"
  }
}
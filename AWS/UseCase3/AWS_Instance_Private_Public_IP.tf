provider "aws" {
  region     = "us-east-1"                                                         # Region
}

resource "aws_vpc" "vpc_1" {
  cidr_block              = "10.0.0.0/16"                                           # VPC Subnet
}
resource "aws_internet_gateway" "gw" {
  vpc_id                  = aws_vpc.vpc_1.id                                        # Gateway Name
}
resource "aws_subnet" "public_1" {                                                  # Subnet details
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.vpc_1.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.1.0/24"
}
resource "aws_route_table" "route-public" {                                        # route address
  vpc_id                  = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "public_1" {                                   
  subnet_id               = aws_subnet.public_1.id
  route_table_id          = aws_route_table.route-public.id
}

resource "aws_instance" "IP_example" {
  ami                           = "ami-06640050dc3f556bb"                              # OS Id
  instance_type                 = "t2.micro"                                           # Instance Type 
  subnet_id                     = aws_subnet.public_1.id
  private_ip                    = "10.0.1.10"

  tags = {
    Name = "Private_IP"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.IP_example.id
  vpc      = true
}

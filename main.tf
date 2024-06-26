provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.myapp_vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

module "myapp-server" {
  source = "./modules/myapp-server"
  instance_type = var.instance_type 
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  image_name = var.image_name
  subnet_id = module.myapp-subnet.subnet.id
  vpc_id = aws_vpc.myapp_vpc.id
}

/*resource "aws_route_table" "myapp_rtb" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_tgw.id
  }

  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}*/

/*resource "aws_route_table_association" "myapp_rtb_asso" {
  subnet_id = aws_subnet.myaap_subnet_1.id
  route_table_id = aws_route_table.myapp_rtb.id
}*/

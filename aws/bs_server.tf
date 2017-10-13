provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "bs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "bs-server-vpc"
  }
}

data "aws_route_table" "selected" {
  vpc_id = "${aws_vpc.bs_vpc.id}"
}

resource "aws_internet_gateway" "bs_gateway" {
  vpc_id = "${aws_vpc.bs_vpc.id}"
}

resource "aws_route" "bs_route" {
  route_table_id            = "${data.aws_route_table.selected.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.bs_gateway.id}"
}

resource "aws_subnet" "bs_subnet" {
  vpc_id     = "${aws_vpc.bs_vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "bs-server-subnet"
  }
}

resource "aws_eip" "default" {
  instance = "${aws_instance.bs_server.id}"
  vpc      = true
}

# Our default security group to access
# the instances over SSH and BS Ports
resource "aws_security_group" "bs_server" {
  name        = "bs_server"
  description = "Public IP for the Server"
  vpc_id      = "${aws_vpc.bs_vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # BS access from anywhere
  ingress {
    from_port   = 27000
    to_port     = 27050
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bs_server" {
  depends_on = ["aws_internet_gateway.bs_gateway"]

  ami           = "${var.ami_id}"
  instance_type = "${var.instance_size}"
  subnet_id     = "${aws_subnet.bs_subnet.id}"

  vpc_security_group_ids = ["${aws_security_group.bs_server.id}"]

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:
  #
  key_name = "${var.key_name}"

  user_data = "${file("setup_script.sh")}"
}
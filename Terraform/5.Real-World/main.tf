provider "aws" {
  region = "us-east-2"
}
variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "real-world" {
    key_name = "shiva123.pem"
    public_key = file("C:/Users/cheri/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id =  aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "websg" {
  name = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from vpc"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port = 20
    to_port = 20
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "nm"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "shiva" {
  ami = "ami-0cb91c7de36eed2cb"
  instance_type = "t2.micro"
  key_name = aws_key_pair.real-world.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id = aws_subnet.sub1.id
  
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file ("~/.ssh/id_rsa")
    host = self.public_ip
  }
  provisioner "file" {    
    source = "C:/Users/cheri/OneDrive/Desktop/New folder/JS Projects/7.Ouestion1"
    destination = "/home/ubuntu/website"
  }
  provisioner "remote-exec" {
    inline = [ 
        "echo 'hello from the remote instance'",
        "sudo apt update -y",
        "sudo apt-get install -y nginx",
        "sudo rm -rf /var/www/html/*",
        "sudo cp -r /home/ubuntu/website/* /var/www/html/", 
        "sudo systemctl restart nginx",
    ]
  }
  tags = {
    Name = "Terraform-web-server"
  }
}



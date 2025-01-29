provider "aws" {
    region = "us-east-2"
}

module "ec2_instances" {
  source = "./module/ec2_instance"
  ami_value = "ami-036841078a4b68e14"
  instance_type_value = "t2.micro"
}
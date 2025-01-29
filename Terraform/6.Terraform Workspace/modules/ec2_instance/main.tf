provider "aws" {
    region = "us-east-2"  
}

variable "ami" {
  description = "ami value"
  default = ""
}
variable "instance_type" {
  description = "instance_type value"
  default = ""
}

resource "aws_instance" "workspace" {
    ami = var.ami
    instance_type = var.instance_type
  
}
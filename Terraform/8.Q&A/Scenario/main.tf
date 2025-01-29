provider "aws" {
  region = "us-east-2"
}

import {
  id = "i-03373712c461cacaa"

  to = aws_instance.example
  
}
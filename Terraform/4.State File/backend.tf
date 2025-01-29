terraform {
  backend "s3" {
    bucket = "shiva1-bucket-backend-123"
    key    = "path/to/my/key"
    region = "us-east-2"
  }
}
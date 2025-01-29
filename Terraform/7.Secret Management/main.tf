provider "aws" {
    region = "us-east-2"
}

provider "vault" {
  address = "http://18.188.101.140:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "5601154e-0624-2d39-5559-2c49263ebd03"
      secret_id = "d3fb0890-02bc-88f4-f285-f933b343c6fe"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "example" {
  ami = "  "
}
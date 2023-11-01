terraform {
  backend "s3" {
    bucket = "learn-terraform-remote-state"
    key = "terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "state-lock"
  }
}
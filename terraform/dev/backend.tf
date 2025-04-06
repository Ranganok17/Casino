terraform {
  backend "s3" {
    bucket         = "casino-radu-dev"
    key            = "casino-dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
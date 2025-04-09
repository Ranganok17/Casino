terraform {
  backend "s3" {
    bucket         = "casino-radu-prod"
    key            = "casino-prod/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
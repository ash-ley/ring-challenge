terraform {
  backend "s3" {
      bucket = "talent-academy-439272626435-tfstate-ashley"
      key = "sprint2/ring-challenge/terraform.tfstates"
      dynamodb_table = "terraform-lock"
  }
}
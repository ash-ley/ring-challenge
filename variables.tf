variable "cidr-block" {
    description = "CIDR block for my VPC"
    type = string
    default = "192.168.0.0/16"
    }
variable "instance_type" {
    description = "The instance type for my EC2"
    type = string
    default = "t2.micro"
}
variable "private_cidr" {
    description = "CIDR block for my private subnet"
    type = string
}
variable "public_cidr" {
    description = "CIDR block for my public subnet"
    type = string
}
variable "keypair_name" {
  description = "The name of my keypair"
  type = string
}
variable "key_location" {
  description = "The location of your private key"
  type = string
}
variable "instance_count" {
  description = "Number of instances I want inside my private subnet"
  type = string
  default = "5"
}
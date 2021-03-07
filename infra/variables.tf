variable "aws_profile" {
  default = "default"
}
variable "aws_region" {
  # us-east-1 is apparently cheapest
  default = "us-east-1"
}
variable "your_ip" {}
variable "instance_type" {
  default = "t3.micro"
}
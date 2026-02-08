resource "aws_vpc" "kev-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "kev-instance" {
    ami = ""
    
}
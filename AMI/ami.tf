resource "aws_ami_from_instance" "CAPSTONE" {
  name               = "CAPSTONE"
  source_instance_id = ""
}
output "ami_id" {
  value = aws_from_instance.CAPSTONE.ami
}
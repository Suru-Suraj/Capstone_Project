resource "aws_key_pair" "capstone" {
  key_name = "capstone"
  public_key = file("capstone.pem")  # Replace with the path to your public key file
}

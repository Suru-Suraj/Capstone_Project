variable "source_instance_id" {
  description = "The ID of the source AWS EC2 instance from which to create the AMI."
  type        = string
  default     = ""  # Provide a default value or remove it if you want to specify it at runtime
}

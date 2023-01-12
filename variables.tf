variable "instance_ids" {
  type = list(string)
  default = [ "i-1234", "i-1234" ] ## Add instance ID here
}

variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a"]
}

variable "volume_name_prefix" {
  type = string
  default = "my-ebs-volume"
}

variable "volume_tags" {
  type = list(map(string))
  default = [{ "Key" = "EBS", "Value" = "terraform" }]
}

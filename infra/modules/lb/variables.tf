variable "env" {
  type = string
}

variable "NCP_ACCESS_KEY" {
  type = string
  sensitive = true
}

variable "NCP_SECRET_KEY" {
  type = string
  sensitive = true
}

variable "vpc_no" {
  type = string
}

variable "be_instance_no" {
  type = string
}

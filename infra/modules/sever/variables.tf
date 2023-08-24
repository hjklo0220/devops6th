variable "password" {
  type = string
  sensitive = true
}

variable "NCP_ACCESS_KEY" {
  type = string
  sensitive = true
}

variable "NCP_SECRET_KEY" {
  type = string
  sensitive = true
}

variable "POSTGRES_DB" {
  type = string
  sensitive = true
}

variable "POSTGRES_USER" {
  type = string
  sensitive = true
}

variable "POSTGRES_PASSWORD" {
  type = string
  sensitive = true
}

variable "POSTGRES_PORT" {
  type = string
  sensitive = true
}

variable "DJANGO_SETTINGS_MODULE" {
  type = string
  sensitive = true
}

variable "DJANGO_SECRET_KEY" {
  type = string
  sensitive = true
}

variable "env" {
  type = string
}

variable "vpc_no" {
  type = string
}
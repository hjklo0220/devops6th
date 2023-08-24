# ncp provider require
variable "NCP_ACCESS_KEY" {
  type = string
  sensitive = true
}

variable "NCP_SECRET_KEY" {
  type = string
  sensitive = true
}

variable "region" {
  type = string
  sensitive = true
}

variable "site" {
  type = string
  sensitive = true
}

variable "support_vpc" {
  type = string
  sensitive = true
}

variable "password" {
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

variable "DJANGO_SECRET_KEY" {
  type = string
  sensitive = true
}

variable "DJANGO_SETTINGS_MODULE" {
  type = string
  sensitive = true
}

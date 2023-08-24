// 변수 지정 (실행시 입력받음) "export TF_VAR_password=" 지정해주면 안물어봄
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

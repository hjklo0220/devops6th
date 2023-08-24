terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

// Configure the ncloud provider
provider "ncloud" {
  access_key = var.NCP_ACCESS_KEY
  secret_key = var.NCP_SECRET_KEY
  region = "KR"
  site = "PUBLIC"
  support_vpc = true
}

locals {
  env = "staging"
}

module "servers" {
  source = "../modules/sever"

  password = var.password
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  POSTGRES_DB = var.POSTGRES_DB
  POSTGRES_USER = var.POSTGRES_USER
  POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
  POSTGRES_PORT = var.POSTGRES_PORT
  DJANGO_SETTINGS_MODULE = var.DJANGO_SETTINGS_MODULE
  DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  env = local.env
  vpc_no = module.vpc.vpc_no
}

module "vpc" {
  source = "../modules/network"

  env = local.env
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
}

module "lb" {
  source = "../modules/lb"

  env = local.env
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  vpc_no = module.vpc.vpc_no
  be_instance_no = module.servers.be_instance_no
}

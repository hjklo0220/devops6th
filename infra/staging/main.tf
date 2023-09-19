terraform {
  backend "local" {
    path = "/Users/junyoung_kim/DRF_study/terraform_study/states/staging.tfstate"
  }
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

module "be_server" {
  source = "../modules/sever"

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  env = local.env
  vpc_no = module.vpc.vpc_no
  
  init_script_envs = {
    password = var.password
    DB_HOST = ncloud_public_ip.db.public_ip
    POSTGRES_DB = var.POSTGRES_DB
    POSTGRES_USER = var.POSTGRES_USER
    POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    POSTGRES_PORT = var.POSTGRES_PORT
    DJANGO_SETTINGS_MODULE = var.DJANGO_SETTINGS_MODULE
    DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  }
  init_script_path = "be_init_script.tftpl"
  subnet_no = module.vpc.subnet_no
  server_image_product_code = data.ncloud_server_products.sm.server_image_product_code
  product_code = data.ncloud_server_products.sm.product_code
  name = "be"
  acg_port_range = "8000"
}

module "db_server" {
  source = "../modules/sever"

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  env = local.env
  vpc_no = module.vpc.vpc_no
  
  init_script_envs = {
    password = var.password
    POSTGRES_DB = var.POSTGRES_DB
    POSTGRES_USER = var.POSTGRES_USER
    POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
    POSTGRES_PORT = var.POSTGRES_PORT
  }
  init_script_path = "db_init_script.tftpl"
  subnet_no = module.vpc.subnet_no
  server_image_product_code = data.ncloud_server_products.sm.server_image_product_code
  product_code = data.ncloud_server_products.sm.product_code
  name = "db"
  acg_port_range = "5432"
}

module "vpc" {
  source = "../modules/network"

  env = local.env
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
}

module "lb" {
  source = "../modules/lb"

  env = "prod"
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  vpc_no = module.vpc.vpc_no
  be_instance_no = module.be_server.instance_no
}


resource "ncloud_public_ip" "be_server" {
    server_instance_no = module.be_server.instance_no //ncloud_server.server.instance_no
}

resource "ncloud_public_ip" "db" {
    server_instance_no = module.db_server.instance_no
}

data "ncloud_server_products" "sm" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  product_code = "SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002"
}
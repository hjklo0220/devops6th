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

resource "ncloud_login_key" "loginkey" {
  key_name = "key-${var.env}"
}

# resource "ncloud_vpc" "lion-vpc" {
#   ipv4_cidr_block = "10.1.0.0/16"
#   name = "lion-tf-${var.env}"
# }
data "ncloud_vpc" "lion-vpc" {
  id = var.vpc_no
}

resource "ncloud_subnet" "main" {
  vpc_no         = data.ncloud_vpc.lion-vpc.vpc_no
  subnet         = cidrsubnet(data.ncloud_vpc.lion-vpc.ipv4_cidr_block, 8, 1)
  zone           = "KR-2"
  network_acl_no = data.ncloud_vpc.lion-vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
  name = "lion-subnet-${var.env}"
}

resource "ncloud_public_ip" "be_server" {
    server_instance_no = ncloud_server.server.instance_no
}

resource "ncloud_public_ip" "db" {
    server_instance_no = ncloud_server.db.instance_no
}

# init script be
resource "ncloud_init_script" "be" {
  name    = "set-be-${var.env}"
  content = templatefile("${path.module}/be_init_script.tftpl", {
  password = var.password
  DB_HOST = ncloud_public_ip.db.public_ip
  POSTGRES_DB = var.POSTGRES_DB
  POSTGRES_USER = var.POSTGRES_USER
  POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
  POSTGRES_PORT = var.POSTGRES_PORT
  DJANGO_SETTINGS_MODULE = var.DJANGO_SETTINGS_MODULE
  DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  })
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.main.id
  name                      = "be-${var.env}"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.be.init_script_no
  network_interface {
    network_interface_no = ncloud_network_interface.be.id
    order = 0
  }
#   access_control_group_configuration_no_list = [ ncloud_access_control_group.be-acg.id ]
}

data "ncloud_server_products" "sm" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  //SVR.VSVR.HICPU.C002.M004.NET.SSD.B050.G002
  //SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }

  filter {
    name   = "cpu_count"
    values = ["2"]
  }

  filter {
    name   = "memory_size"
    values = ["4GB"]
  }

  filter {
    name   = "base_block_storage_size"
    values = ["50GB"]
  }

  filter {
    name   = "product_type"
    values = ["HICPU"]
  }

  output_file = "product.json"
}

# init script db
resource "ncloud_init_script" "db" {
  name    = "set-db-${var.env}"
  content = templatefile("${path.module}/db_init_script.tftpl", {
  password = var.password
  POSTGRES_DB = var.POSTGRES_DB
  POSTGRES_USER = var.POSTGRES_USER
  POSTGRES_PASSWORD = var.POSTGRES_PASSWORD
  POSTGRES_PORT = var.POSTGRES_PORT
  })
}

# db
resource "ncloud_server" "db" {
  subnet_no                 = ncloud_subnet.main.id
  name                      = "db-${var.env}"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.db.init_script_no
  network_interface {
    network_interface_no = ncloud_network_interface.db.id
    order = 0
  }
}

// ACG 설정
resource "ncloud_access_control_group" "be-acg" {
  name = "be-acg-${var.env}"
  vpc_no = data.ncloud_vpc.lion-vpc.id
}

resource "ncloud_access_control_group_rule" "be-acg-rule" {
  access_control_group_no = ncloud_access_control_group.be-acg.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8000"
    description = "accept 8000 port for django"
  }
}

// network interface 생성후 acg적용
resource "ncloud_network_interface" "be" {
    name                  = "be-nic-${var.env}"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
        data.ncloud_vpc.lion-vpc.default_access_control_group_no,
        ncloud_access_control_group.be-acg.id,
    ]
}

resource "ncloud_access_control_group" "db-acg" {
  name = "db-acg-${var.env}"
  vpc_no = data.ncloud_vpc.lion-vpc.id
}

resource "ncloud_access_control_group_rule" "db-acg-rule" {
  access_control_group_no = ncloud_access_control_group.db-acg.id

  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "5432"
    description = "accept 5432 port for postgres"
  }
}

resource "ncloud_network_interface" "db" {
    name                  = "db-nic-${var.env}"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
        data.ncloud_vpc.lion-vpc.default_access_control_group_no,
        ncloud_access_control_group.db-acg.id,
    ]
}
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

resource "ncloud_login_key" "loginkey" {
  key_name = "test-key"
}

resource "ncloud_vpc" "lion-vpc" {
  ipv4_cidr_block = "10.1.0.0/16"
  name = "lion-tf"
}

resource "ncloud_subnet" "main" {
  vpc_no         = ncloud_vpc.lion-vpc.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.lion-vpc.ipv4_cidr_block, 8, 1)
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.lion-vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
  name = "lion-tf-sub"
}

# init script
resource "ncloud_init_script" "init" {
  name    = "set-docker-tf"
  content = templatefile("${path.module}/main_init_script.tftpl", {
    password = var.password
  })
}

resource "ncloud_server" "server" {
  subnet_no                 = ncloud_subnet.main.id
  name                      = "be-staging"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.init.init_script_no
  network_interface {
    network_interface_no = ncloud_network_interface.be.id
    order = 0
  }
#   access_control_group_configuration_no_list = [ ncloud_access_control_group.be-acg.id ]
}

resource "ncloud_public_ip" "be_server" {
    server_instance_no = ncloud_server.server.instance_no
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



output "products" {
  value = {
    for product in data.ncloud_server_products.sm.server_products:
    product.id => product.product_name
  }
}

# 서버 ip가져오는 방법
output "be_public_ip" {
  value = ncloud_public_ip.be_server.public_ip
}

output "db_public_ip" {
  value = ncloud_public_ip.db.public_ip
}


# db
resource "ncloud_server" "db" {
  subnet_no                 = ncloud_subnet.main.id
  name                      = "db-staging"
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code
  login_key_name            = ncloud_login_key.loginkey.key_name
  init_script_no = ncloud_init_script.init.init_script_no
  network_interface {
    network_interface_no = ncloud_network_interface.db.id
    order = 0
  }
}

resource "ncloud_public_ip" "db" {
    server_instance_no = ncloud_server.db.instance_no
}

// ACG 설정
resource "ncloud_access_control_group" "be-acg" {
  name = "be-acg"
  vpc_no = ncloud_vpc.lion-vpc.id
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
    name                  = "be-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
        ncloud_vpc.lion-vpc.default_access_control_group_no,
        ncloud_access_control_group.be-acg.id,
    ]
}

resource "ncloud_access_control_group" "db-acg" {
  name = "db-staging-acg"
  vpc_no = ncloud_vpc.lion-vpc.id
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
    name                  = "db-nic"
    subnet_no             = ncloud_subnet.main.id
    access_control_groups = [
        ncloud_vpc.lion-vpc.default_access_control_group_no,
        ncloud_access_control_group.db-acg.id,
    ]
}

# loadbalance
resource "ncloud_lb" "be-staging" {
  name = "be-lb-staging"
  network_type = "PUBLIC"
  type = "NETWORK_PROXY"
  subnet_no_list = [ ncloud_subnet.be-lb.subnet_no ]
}

# lb-subnet
resource "ncloud_subnet" "be-lb" {
  vpc_no         = ncloud_vpc.lion-vpc.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.lion-vpc.ipv4_cidr_block, 8, 2)
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.lion-vpc.default_network_acl_no
  subnet_type    = "PRIVATE"
  usage_type     = "LOADB"
  name = "be-lb-subnet"
}

# target group
resource "ncloud_lb_target_group" "tg" {
  vpc_no   = ncloud_vpc.lion-vpc.vpc_no
  protocol = "PROXY_TCP"
  target_type = "VSVR"
  port        = 8000
  description = "for test"
  health_check {
    protocol = "TCP"
    http_method = "GET"
    port           = 8000
    url_path       = "/admin"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
  algorithm_type = "RR"
  name = "lion-tf-tg"
}

resource "ncloud_lb_listener" "lb-listener" {
  load_balancer_no = ncloud_lb.be-staging.load_balancer_no
  protocol = "TCP"
  port = 80
  target_group_no = ncloud_lb_target_group.tg.target_group_no
}

# target group attachment
resource "ncloud_lb_target_group_attachment" "test" {
  target_group_no = ncloud_lb_target_group.tg.target_group_no
  target_no_list = [ncloud_server.server.instance_no]
}

output "lb" {
  value = ncloud_lb.be-staging.domain
}

# data "ncloud_access_control_group" "default" {
#     id = "124475"
# }

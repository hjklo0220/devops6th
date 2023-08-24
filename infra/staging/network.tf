
# # lb-subnet
# resource "ncloud_subnet" "be-lb" {
#   vpc_no         = ncloud_vpc.lion-vpc.vpc_no
#   subnet         = cidrsubnet(ncloud_vpc.lion-vpc.ipv4_cidr_block, 8, 2)
#   zone           = "KR-2"
#   network_acl_no = ncloud_vpc.lion-vpc.default_network_acl_no
#   subnet_type    = "PRIVATE"
#   usage_type     = "LOADB"
#   name = "be-lb-subnet"
# }


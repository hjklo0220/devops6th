# // 서브넷 생성
# resource "ncloud_subnet" "be-prod-lb" {
#   name = "be-prod-lb-subnet"
#   vpc_no = ncloud_vpc.prod-vpc.vpc_no
#   subnet = cidrsubnet(ncloud_vpc.prod-vpc.ipv4_cidr_block, 8, 2)
#   zone = "KR-2"
#   network_acl_no = ncloud_vpc.prod-vpc.default_network_acl_no
#   subnet_type = "PRIVATE"
#   usage_type = "LOADB"
# }

# // 로드벨런서 생성
# resource "ncloud_lb" "be-prod" {
#   name  = "be-lb-prod"
#   network_type = "PUBLIC"
#   type = "NETWORK_PROXY"
#   subnet_no_list = [ ncloud_subnet.be-prod-lb.subnet_no ]
# }

# resource "ncloud_lb_target_group" "tg-prod" {
#   name = "prod-tg"
#   vpc_no = ncloud_vpc.prod-vpc.vpc_no
#   protocol = "PROXY_TCP"
#   target_type = "VSVR"
#   port        = 8000
#   description = "for prod be"
#   health_check {
#     protocol = "TCP"
#     http_method = "GET"
#     port           = 8000
#     url_path       = "/admin"
#     cycle          = 30
#     up_threshold   = 2
#     down_threshold = 2
#   }
#   algorithm_type = "RR"
# }

# resource "ncloud_lb_listener" "lb-listener" {
#   load_balancer_no = ncloud_lb.be-prod.load_balancer_no
#   protocol = "TCP"
#   port = 80
#   target_group_no = ncloud_lb_target_group.tg-prod.target_group_no
# }

# resource "ncloud_lb_target_group_attachment" "tg-att" {
#   target_group_no = ncloud_lb_target_group.tg-prod.target_group_no
#   target_no_list = [ ncloud_server.be-prod.instance_no ]
# }
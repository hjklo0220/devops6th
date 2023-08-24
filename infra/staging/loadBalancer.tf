# # loadbalance
# resource "ncloud_lb" "be-staging" {
#   name = "be-lb-staging"
#   network_type = "PUBLIC"
#   type = "NETWORK_PROXY"
#   subnet_no_list = [ ncloud_subnet.be-lb.subnet_no ]
# }

# # target group
# resource "ncloud_lb_target_group" "tg" {
#   vpc_no   = ncloud_vpc.lion-vpc.vpc_no
#   protocol = "PROXY_TCP"
#   target_type = "VSVR"
#   port        = 8000
#   description = "for test"
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
#   name = "lion-tf-tg"
# }

# resource "ncloud_lb_listener" "lb-listener" {
#   load_balancer_no = ncloud_lb.be-staging.load_balancer_no
#   protocol = "TCP"
#   port = 80
#   target_group_no = ncloud_lb_target_group.tg.target_group_no
# }

# # target group attachment
# resource "ncloud_lb_target_group_attachment" "test" {
#   target_group_no = ncloud_lb_target_group.tg.target_group_no
#   target_no_list = [ncloud_server.server.instance_no]
# }
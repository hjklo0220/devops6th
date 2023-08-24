# output "products" {
#   value = {
#     for product in data.ncloud_server_products.sm.server_products:
#     product.id => product.product_name
#   }
# }

# output "be_public_ip" {
#   value = ncloud_public_ip.be_server.public_ip
# }

# output "db_public_ip" {
#   value = ncloud_public_ip.db.public_ip
# }

# output "lb" {
#   value = ncloud_lb.be-staging.domain
# }
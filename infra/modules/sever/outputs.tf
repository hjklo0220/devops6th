# output "be_public_ip" {
#   value = ncloud_public_ip.be_server.public_ip
# }

# output "db_public_ip" {
#   value = ncloud_public_ip.db.public_ip
# }

output "instance_no" {
  value = ncloud_server.main.instance_no
}

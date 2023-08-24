output "be_public_ip" {
  value = ncloud_public_ip.be_server.public_ip
}

output "db_public_ip" {
  value = ncloud_public_ip.db.public_ip
}

output "be_instance_no" {
  value = ncloud_server.server.instance_no
}

output "be-prod-ip" {
  value = ncloud_public_ip.be_server.public_ip
}

output "db-prod-ip" {
  value = ncloud_public_ip.db_server.public_ip
}

output "lb-prod" {
  value = module.lb.lb_domain
}
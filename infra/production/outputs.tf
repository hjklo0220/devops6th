output "be-prod-ip" {
  value = module.servers.be_public_ip
}

output "db-prod-ip" {
  value = module.servers.db_public_ip
}

output "lb-prod" {
  value = module.lb.lb_domain
}
output "be_public_ip" {
  value = module.servers.be_public_ip
}

output "db_public_ip" {
  value = module.servers.db_public_ip
}

output "lb" {
  value = module.lb.lb_domain
}
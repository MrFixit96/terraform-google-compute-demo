output "private_ip" {
  description = "list private ip on compute instance"
  value       = module.compute.network_interface.0.network_ip
}

output "public_ip" {
  description = "list public ip on compute instance if there is one"
  value       = module.compute.network_interface.0.access_config.0.nat_ip
}

/*
output "public_ssh_key" {
  description = "The public key we inserted"
  value       = [module.compute.*.metadata]
}
*/

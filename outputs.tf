output "private_ip" {
  description = "list private ip on compute instance"
  value       = module.compute.*.private_ip
}

output "public_ip" {
  description = "list public ip on compute instance if there is one"
  value       = module.compute.*.public_ip
}

/*
output "public_ssh_key" {
  description = "The public key we inserted"
  value       = [module.compute.*.metadata]
}
*/

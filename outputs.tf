
output "avx_controller_public_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
}

output "avx_controller_private_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
}

output "avx_controller_vnet" {
  value = module.aviatrix_controller_build.aviatrix_controller_vnet
}

output "avx_controller_rg" {
  value = module.aviatrix_controller_build.aviatrix_controller_rg
}


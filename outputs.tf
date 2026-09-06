output "name" {
  description = "Name of the LXC."
  value       = proxmox_virtual_environment_container.base_lxc.initialization[0].hostname
}

output "ipv4_address" {
  description = "Primary IPv4 address of the LXC."
  value       = proxmox_virtual_environment_container.base_lxc.ipv4["eth0"]
}

output "id" {
  description = "ID of the LXC."
  value       = proxmox_virtual_environment_container.base_lxc.id
}

output "node_name" {
  description = "Node name of the LXC."
  value       = proxmox_virtual_environment_container.base_lxc.node_name
}

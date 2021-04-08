output "public_IP_Load_Balancer" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public HTTP service IP address of the load balancer in front of the webservers."
}

output "network_Interface_Private_IP" {
  description = "Private IP addresses of the VM network interfaces"
  value       = azurerm_network_interface.main.*.private_ip_address
}

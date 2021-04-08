output "public_IP_LB" {
  value       = azurerm_public_ip.pip.ip_address
  description = "The public IP address of the load balancer in front of the web servers."
}

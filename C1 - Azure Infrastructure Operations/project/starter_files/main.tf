# Based on: https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/linux/load-balanced/main.tf
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
  name = "${var.resource_group_name}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}


resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_network_interface" "main" {
  count               = var.number_of_virtual_machines
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.prefix}-avset"
  location                     = azurerm_resource_group.main.location
  resource_group_name          = azurerm_resource_group.main.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_network_security_group" "webserver" {
  count               = var.number_of_virtual_machines
  name                = "${var.prefix}-webserverNSG-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "${var.application_port}"
    destination_address_prefix = azurerm_subnet.internal.address_prefix
  }
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  count                     = var.number_of_virtual_machines
  #network_interface_id      = azurerm_network_interface.example.id
  network_interface_id      = element(azurerm_network_interface.main.*.id, count.index)
  #network_security_group_id = azurerm_network_security_group.example.id
  network_security_group_id = element(azurerm_network_security_group.webserver.*.id, count.index)
}

resource "azurerm_lb" "example" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.prefix}-publicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  
  tags = {
    udacity = "Project Web Server"
  }
}

resource "azurerm_lb_probe" "example" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "${var.prefix}-http-running-probe"
  port                = 80
}

resource "azurerm_lb_backend_address_pool" "example" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "${var.prefix}-BackEndAddressPool"
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "${var.prefix}-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.example.frontend_ip_configuration[0].name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
  probe_id                       = azurerm_lb_probe.example.id
  idle_timeout_in_minutes        = 15
  enable_tcp_reset               = true
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.main.*.id, count.index)
}

data "azurerm_image" "custom" {
    name = "UdacityWebServerPackerImage"
    resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_virtual_machine" "main" {
    count                 = local.instance_count
    name                  = "${var.prefix}-vm${count.index}"
    resource_group_name   = azurerm_resource_group.main.name
    location              = azurerm_resource_group.main.location
    network_interface_ids = [azurerm_network_interface.main[count.index].id,]
    vm_size               = "Standard_B1s"
    availability_set_id   = azurerm_availability_set.avset.id
    storage_image_reference {
        id = "${data.azurerm_image.custom.id}"
    }
    storage_os_disk {
        name              = "${var.prefix}-osdisk${count.index}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "${var.prefix}-vm${count.index}"
        admin_username = "${var.admin_user}"
    }
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.admin_user}/.ssh/authorized_keys"
            key_data = file("${var.admin_ssh_public_key_file}")
        }
    }
    tags = {
        udacity = "Project Web Server"
    }
}

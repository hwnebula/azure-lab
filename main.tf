resource "azurerm_resource_group" "terraform-rg" {
  name     = var.rgname
  location = var.rglocation
}

# Create a resource group if ita doesn't exist
resource "azurerm_resource_group" "Lab-Infrastructure" {
  name     = var.rgname
  location = var.rglocation
}

# Create virtual network
resource "azurerm_virtual_network" "Lab-VNet" {
  name                = "Lab-VNet"
  address_space       = ["10.10.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.Lab-Infrastructure.name
}

# Create subnet
resource "azurerm_subnet" "Host-Subnet" {
  name                 = "Host-Subnet"
  resource_group_name  = azurerm_resource_group.Lab-Infrastructure.name
  virtual_network_name = azurerm_virtual_network.Lab-VNet.name
  address_prefix       = "10.10.10.0/24"
}

/* # Create network interface win10
 resource "azurerm_network_interface" "win10_nic" {
  name                = "win10_nic"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.Lab-Infrastructure.name

  ip_configuration {
    name                          = "win10_nic_conf"
    subnet_id                     = azurerm_subnet.Host-Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine
 resource "azurerm_windows_virtual_machine" "win10" {
  name                  = "win10"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.Lab-Infrastructure.name
  network_interface_ids = [azurerm_network_interface.win10_nic.id]
  size                  = "Standard_B2ms"
  admin_username      = "xadmin"
  admin_password      = "Complex.Password"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  } 

}
 */
# Create network interface
/* resource "azurerm_network_interface" "win10_nic" {
  name                = "win10_nic"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.Lab-Infrastructure.name

  ip_configuration {
    name                          = "win10_nic_conf"
    subnet_id                     = azurerm_subnet.Host-Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
} */

# Create virtual machine
/* resource "azurerm_windows_virtual_machine" "win10" {
  name                  = "win10"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.Lab-Infrastructure.name
  network_interface_ids = [azurerm_network_interface.win10_nic.id]
  size                  = "Standard_B2ms"
  admin_username      = "ADadmin"
  admin_password      = "Complex.Password"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  } 

} */

# Create NSG
resource "azurerm_network_security_group" "RDP-NSG" {
  name                = "RDP-NSG"
  location            = azurerm_resource_group.Lab-Infrastructure.location
  resource_group_name = azurerm_resource_group.Lab-Infrastructure.name
}

resource "azurerm_network_security_rule" "Lab-Infrastructure" {
  name                        = "PermitRDP"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Lab-Infrastructure.name
  network_security_group_name = azurerm_network_security_group.RDP-NSG.name
}

/* # Create Public IP address
resource "azurerm_public_ip" "example" {
  name                = "pip-eus-win10"
  resource_group_name = azurerm_resource_group.Lab-Infrastructure.name
  location            = "eastus"
  allocation_method   = "Static"

  tags = {
    environment = "test"
  }
} */
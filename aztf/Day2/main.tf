resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnets" {
  count = length(var.subnet_prefixes)
  name                 = "subnets-${count.index}"
  address_prefixes     = [element(var.subnet_prefixes, count.index)]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_security_group" "nsg" {
  count               = 2
  name                = "nsg-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  count                         = 2
  name                          = "allow-ssh-${count.index}"
  priority                      = 1001
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "Tcp"
  source_port_range             = "*"
  destination_port_range        = "22"
  source_address_prefix         = "*"
  destination_address_prefix    = "*"
  resource_group_name           = azurerm_resource_group.rg.name
  network_security_group_name   = azurerm_network_security_group.nsg[count.index].name
}

resource "azurerm_public_ip" "public_ip" {
  count               = 2
  name                = "vm-public-ip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [element(["1", "2"], count.index)]
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "vm-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg[count.index].id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = "vm-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]
  zone   = "${(count.index % 3) + 1}"  # Distributes across zones 1, 2, 3

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Update path to your public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "Demo"
  }
}
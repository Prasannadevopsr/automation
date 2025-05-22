# resource "azurerm_virtual_network" "vnet" {
#   name                = var.vnet_name
#   address_space       = var.vnet_address_space
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "subnet-0" {
#   name                 = var.subnet_name_0
#   address_prefixes     = [var.subnet_address_prefix_0]
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

# resource "azurerm_subnet" "subnet-1" {
#   name                 = var.subnet_name_1
#   address_prefixes     = [var.subnet_address_prefix_1]
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

# resource "azurerm_subnet" "subnet-2" {
#   name                 = var.subnet_name_2
#   address_prefixes     = [var.subnet_address_prefix_2]
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

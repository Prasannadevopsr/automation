# Create a resource group
resource "azurerm_resource_group" "aztf-rg" {
  name     = var.rg
  location = var.location
}
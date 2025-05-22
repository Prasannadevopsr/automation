variable "location" {
  default = "eastus2"
}

variable "rg_name" {
  default = "vm-demo-rg"
}

variable "vnet_name" {
  default = "vm-demo-vnet"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_names" {
  default = ["subnet-1", "subnet-2"]
}

variable "subnet_prefixes" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

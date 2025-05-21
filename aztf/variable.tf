variable "location" {
  type = string
}

variable "rg" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_name_0" {
  type = string
}

variable "subnet_name_1" {
  type = string
}

variable "subnet_name_2" {
  type = string
}

variable "subnet_address_prefix_0" {
  type = string
}

variable "subnet_address_prefix_1" {
  type = string
}

variable "subnet_address_prefix_2" {
  type = string
}

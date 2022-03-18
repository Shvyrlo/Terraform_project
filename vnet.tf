# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westus"
}
resource "azurerm_network_security_group" "example" {
  name                = "terraform_security group"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

   security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "terraform_vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "public"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }
}

# resource "azurerm_subnet" "example" {
#   name                 = "${var.subnet_name[count.index]}"
#   resource_group_name  = "${azurerm_resource_group.example.name}"
#   virtual_network_name = "${azurerm_virtual_network.example.name}"
#   address_prefixes     = "${var.subnet_prefix[count.index]}"
#   count = "${length(var.subnet_name)}"
#  }

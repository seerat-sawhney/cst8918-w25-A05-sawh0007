variable "labelPrefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "sawh0007"
}

variable "region" {
  description = "Azure region for deployment"
  type        = string
  default     = "Canada Central"  # You can change this to another region if needed
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "seerat"  # Change this to whatever username you want
}

# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

# Define providers and their config params
provider "azurerm" {
  features {} # Required by AzureRM provider
}

provider "cloudinit" {
  # No additional configuration required
}

resource "azurerm_resource_group" "example" {
  name     = "${var.labelPrefix}-A05-RG"
  location = var.region
}

resource "azurerm_public_ip" "example" {
  name                = "${var.labelPrefix}-A05-PIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.labelPrefix}-A05-VNet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "${var.labelPrefix}-A05-Subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.labelPrefix}-A05-NSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

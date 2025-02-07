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


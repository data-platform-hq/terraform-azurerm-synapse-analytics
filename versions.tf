terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.2"
    }
  }
}

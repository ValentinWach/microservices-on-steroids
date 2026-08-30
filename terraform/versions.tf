terraform {
  required_version = ">= 1.10.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27.0"
    }
  }
}

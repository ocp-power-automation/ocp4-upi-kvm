terraform {
  required_providers {
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "~> 2.1.0"
    }
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 2.1"
    }
  }
  required_version = "~> 0.13.0"
}

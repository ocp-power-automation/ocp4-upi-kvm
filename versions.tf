terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 2.3"
    }
  }
  required_version = "~> 0.13.0"
}

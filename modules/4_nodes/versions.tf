terraform {
  required_providers {
    ignition = {
      source = "terraform-providers/ignition"
      version = "~> 2.1"
    }
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 2.1"
    }
  }
  required_version = "~> 0.13"
}

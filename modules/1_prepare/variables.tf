variable "cluster_domain" {
  default   = "example.com"
}
variable "cluster_id" {
  default   = "test-ocp"
}

variable "bastion" {
    # only one node is supported
    default = {
        memory  = 4096
        vcpu    = 2
    }
}
variable "bastion_image" { default   = "file:///home/libvirt/images/bastion.qcow2" }

variable "rhel_username" {}
variable "rhel_password" {}
variable "private_key" {}
variable "public_key" {}
variable "ssh_agent" {}
variable "host_address" {}

variable "network_cidr" {}
variable "images_path" { default = "/home/libvirt/openshift/images" }

variable "rhel_subscription_username" {}
variable "rhel_subscription_password" {}

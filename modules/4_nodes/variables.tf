variable "cluster_domain" {}
variable "cluster_id" {}

variable "bootstrap" {
    # only one node is supported
    default = {
        memory  = 8192
        vcpu    = 4
    }
}
variable "master" {
    default = {
        count   = 3
        memory  = 8192
        vcpu    = 4
    }
}
variable "worker" {
    default = {
        count   = 2
        memory  = 8192
        vcpu    = 4
    }
}

variable "rhcos_image" {}
variable "storage_pool_name" {}
variable "network_cidr" {}

variable "bastion_ip" {}
variable "network_id" {}

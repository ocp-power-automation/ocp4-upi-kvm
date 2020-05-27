################################################################
# Configure the Libvirt Host values
################################################################
variable "libvirt_uri" {
    description = "The connection URI used to connect to the libvirt host"
    default = "qemu+tcp:///system"
}

# This will be used as jump server to login to the cluster's private network
variable "host_address" {
    description = "Host address where libvirtd is running"
    default = ""
}

variable "images_path" {
    default = "/home/libvirt/openshift-images"
}

################################################################
# Configure the Nodes details
################################################################
variable "bastion_image" {
    description = "Path to RHEL image, local(machine running the terraform) or remote using HTTP(S) url"
    default = "http://remote_server/rhel-8.2-ppc64le-kvm.qcow2"
}

variable "rhcos_image" {
    description = "Path to RHCOS image, local(machine running the terraform) or remote using HTTP(S) url"
    default = "http://remote_server/rhcos-4.3.18-ppc64le-qemu.ppc64le.qcow2"
}

variable "bastion" {
    # only one node is supported
    default = {
        memory  = 4096
        vcpu    = 2
    }
}

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

variable "network_cidr" {
    default = "192.168.27.0/24"
}

variable "rhel_username" {
    default = "root"
}

# This will be used only at the beginning, subsequent logins will be done using the SSH keys.
variable "rhel_password" {
    description = "Password to login to bastion node, leave empty if SSH key is already setup in the image"
    default = "123456"
}

variable "public_key_file" {
    description = "Path to public key file"
    # if empty, will default to ${path.cwd}/data/id_rsa.pub
    default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_file" {
    description = "Path to private key file"
    # if empty, will default to ${path.cwd}/data/id_rsa
    default     = "~/.ssh/id_rsa"
}

variable "private_key" {
    description = "content of private ssh key"
    # if empty string will read contents of file at var.private_key_file
    default = ""
}

variable "public_key" {
    description = "Public key"
    # if empty string will read contents of file at var.public_key_file
    default     = ""
}

# Won't subscribe if rhel_subscription_username is empty (default).
variable "rhel_subscription_username" {
    default = ""
}

variable "rhel_subscription_password" {
    default = ""
}


################################################################
### Instrumentation
################################################################
variable "ssh_agent" {
  description = "Enable or disable SSH Agent. Can correct some connectivity issues. Default: false"
  default     = false
}

variable "installer_log_level" {
  description = "Set the log level required for openshift-install commands"
  default = "info"
}

variable "helpernode_tag" {
    description = "Set the branch/tag name or commit# for using ocp4-helpernode repo"
    # Checkout level for https://github.com/RedHatOfficial/ocp4-helpernode which is used for setting up services required on bastion node
    default = "d6ad30574619ae6427cad9662fe3a4a896a9af11"
}

variable "ansible_extra_options" {
    description = "Extra options string to append to ansible-playbook commands"
    default     = "-v"
}

locals {
    private_key_file    = "${var.private_key_file == "" ? "${path.cwd}/data/id_rsa" : "${var.private_key_file}" }"
    public_key_file     = "${var.public_key_file == "" ? "${path.cwd}/data/id_rsa.pub" : "${var.public_key_file}" }"
    private_key         = "${var.private_key == "" ? file(coalesce(local.private_key_file, "/dev/null")) : "${var.private_key}" }"
    public_key          = "${var.public_key == "" ? file(coalesce(local.public_key_file, "/dev/null")) : "${var.public_key}" }"
}


################################################################
### OpenShift variables
################################################################
variable "openshift_install_tarball" {
    default = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/4.3.18/openshift-install-linux.tar.gz"
}

variable "openshift_client_tarball" {
     default = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/4.3.18/openshift-client-linux.tar.gz"
}

variable "release_image_override" {
    default = ""
}

variable "pull_secret_file" {
    default   = "data/pull-secret.txt"
}

# Must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
variable "cluster_domain" {
    default   = "rhocp.com"
}
# Must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
# Should not be more than 14 characters
variable "cluster_id_prefix" {
    default   = "test-ocp"
}

variable "dns_forwarders" {
    default   = "8.8.8.8; 8.8.4.4"
}

variable "storage_type" {
    #Supported values: nfs (other value won't setup a storageclass)
    default = "none"
}

/* TODO: Storage not tested yet
variable "storage_type" {
    #Supported values: nfs (other value won't setup a storageclass)
    default = "nfs"
}

variable "storageclass_name" {
    default = "managed-nfs-storage"
}

variable "volume_size" {
    # If storage_type = nfs, a new volume of this size will be attached to the bastion node.
    # Value in GB
    default = "300"
}
*/
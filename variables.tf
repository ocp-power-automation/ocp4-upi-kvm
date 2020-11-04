################################################################
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# ©Copyright IBM Corp. 2020
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################

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
        memory  = 8192
        vcpu    = 2
    }
}

variable "bootstrap" {
    # only one node is supported
    default = {
        count   = 1
        memory  = 8192
        vcpu    = 4
    }
}
variable "master" {
    default = {
        count   = 3
        memory  = 16384
        vcpu    = 4
    }
}
variable "worker" {
    default = {
        count   = 2
        memory  = 16384
        vcpu    = 4
    }
}

variable "cpu_mode" {
    description = "Optional guest CPU mode value. Eg: custom, host-passthrough, host-model"
    default     = ""
}

variable "network_cidr" {
    description = "Network subnet range for the cluster nodes"
    default     = "192.168.27.0/24"
}

variable "rhel_username" {
    default     = "root"
}

# This will be used only at the beginning, subsequent logins will be done using the SSH keys.
variable "rhel_password" {
    description = "Password to login to bastion node, leave empty if SSH key is already setup in the image"
    default     = "123456"
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

# Will attempt subscription if this or rhel_subscription_org are set
variable "rhel_subscription_username" {
    default = ""
}

variable "rhel_subscription_password" {
    default = ""
}

# Will attempt subscription if this or rhel_subscription_username are set
variable "rhel_subscription_org" {
    default = ""
}

variable "rhel_subscription_activationkey" {
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
    default = "dd8a0767c677fc862e45b6d70e5d04656ced5d28"
}

variable "install_playbook_tag" {
    description = "Set the branch/tag name or commit# for using ocp4-playbooks repo"
    # Checkout level for https://github.com/ocp-power-automation/ocp4-playbooks which is used for running ocp4 installations steps
    default = "c6e6038dba0856e621697c876bd3a65927f46166"
}

variable "ansible_extra_options" {
    description = "Extra options string to append to ansible-playbook commands"
    default     = "-v"
}

locals {
    private_key_file    = var.private_key_file == "" ? "${path.cwd}/data/id_rsa" : var.private_key_file
    public_key_file     = var.public_key_file == "" ? "${path.cwd}/data/id_rsa.pub" : var.public_key_file
    private_key         = var.private_key == "" ? file(coalesce(local.private_key_file, "/dev/null")) : var.private_key
    public_key          = var.public_key == "" ? file(coalesce(local.public_key_file, "/dev/null")) : var.public_key
}


################################################################
### OpenShift variables
################################################################
variable "openshift_install_tarball" {
    default = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp-dev-preview/latest-4.6/openshift-install-linux.tar.gz"
}

variable "openshift_client_tarball" {
    default = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp-dev-preview/latest-4.6/openshift-client-linux.tar.gz"
}

variable "release_image_override" {
    default = ""
}

variable "pull_secret_file" {
    default = "data/pull-secret.txt"
}

# Must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
variable "cluster_domain" {
    default = "example.com"
}
# Must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
# Should not be more than 14 characters
variable "cluster_id_prefix" {
    default = "test"
}
# Must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character
# Length cannot exceed 14 characters when combined with cluster_id_prefix
variable "cluster_id" {
    default   = ""
}

variable "dns_forwarders" {
    default = "8.8.8.8; 8.8.4.4"
}

variable chrony_config {
    description = "If true, set enable time synchronization via chronyd. Default: true"
    default = true
}

variable chrony_config_servers {
    default = []
    # example: chrony_config_servers = [{server = "clock.example.com", options="iburst"}]
}

variable "storage_type" {
    #Supported values: nfs (other value won't setup a storageclass)
    default = "none"
}

variable "volume_size" {
    # If storage_type = nfs, a new volume of this size will be attached to the bastion node.
    # Value in GB
    default = "300"
}

variable "upgrade_version" {
    description = "OCP upgrade version eg. 4.5.4"
    default = ""
}

variable "upgrade_channel" {
    description = "Upgrade channel having required version availble for cluster upgrade (stable-4.x, fast-4.x, candidate-4.x) eg. stable-4.5"
    default = ""
}

variable "upgrade_pause_time" {
    description = "Number of minutes to pause the playbook execution before starting to check the upgrade status once the upgrade command is executed."
    default = "90"
}

variable "upgrade_delay_time" {
    description = "Number of seconds to wait before re-checking the upgrade status once the playbook execution resumes."
    default = "600"
}

################################################################
# Local registry variables ( used only in disconnected install )
################################################################
variable "enable_local_registry" {
    description = "Set to true to enable usage of local registry for restricted network install."
    type = bool
    default = false
}

variable "local_registry_image" {
    description = "Name of the image used for creating the local registry container."
    default = "docker.io/ibmcom/registry-ppc64le:2.6.2.5"
}

variable "ocp_release_tag" {
    description = "The version of OpenShift you want to sync."
    default = "4.6.1-ppc64le"
}

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

variable "cpu_mode" {}

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
variable "rhel_subscription_org" {}
variable "rhel_subscription_activationkey" {}

variable "storage_type" {}
variable "volume_size" {}

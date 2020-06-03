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

terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
    uri = var.libvirt_uri
}

resource "random_id" "label" {
    byte_length = "2" # Since we use the hex, the word lenght would double
    prefix = "${var.cluster_id_prefix}-"
}

module "prepare" {
    source                          = "./modules/1_prepare"

    cluster_domain                  = var.cluster_domain
    cluster_id                      = "${random_id.label.hex}"
    bastion                         = var.bastion
    bastion_image                   = var.bastion_image
    rhel_username                   = var.rhel_username
    rhel_password                   = var.rhel_password
    private_key                     = local.private_key
    public_key                      = local.public_key
    ssh_agent                       = var.ssh_agent
    host_address                    = var.host_address
    network_cidr                    = var.network_cidr
    images_path                     = var.images_path
    rhel_subscription_username      = var.rhel_subscription_username
    rhel_subscription_password      = var.rhel_subscription_password
    storage_type                    = var.storage_type
    volume_size                     = var.volume_size
}

module "nodes" {
    source                          = "./modules/4_nodes"

    bastion_ip                      = module.prepare.bastion_ip
    cluster_domain                  = var.cluster_domain
    cluster_id                      = "${random_id.label.hex}"
    bootstrap                       = var.bootstrap
    master                          = var.master
    worker                          = var.worker
    rhcos_image                     = var.rhcos_image
    storage_pool_name               = module.prepare.storage_pool_name
    network_cidr                    = var.network_cidr
    network_id                      = module.prepare.network_id
}

module "install" {
    source                          = "./modules/5_install"

    cluster_domain                  = var.cluster_domain
    cluster_id                      = "${random_id.label.hex}"
    dns_forwarders                  = var.dns_forwarders
    gateway_ip                      = cidrhost(var.network_cidr,1)
    cidr                            = var.network_cidr
    allocation_pools                = [{"start": cidrhost(var.network_cidr,3), "end": cidrhost(var.network_cidr,-2)}]
    bastion_ip                      = module.prepare.bastion_ip
    rhel_username                   = var.rhel_username
    private_key                     = local.private_key
    ssh_agent                       = var.ssh_agent
    jump_host                       = var.host_address
    bootstrap_ip                    = module.nodes.bootstrap_ip
    master_ips                      = module.nodes.master_ips
    worker_ips                      = module.nodes.worker_ips
    bootstrap_mac                   = module.nodes.bootstrap_mac
    master_macs                     = module.nodes.master_macs
    worker_macs                     = module.nodes.worker_macs
    public_key                      = local.public_key
    pull_secret                     = file(coalesce(var.pull_secret_file, "/dev/null"))
    openshift_install_tarball       = var.openshift_install_tarball
    openshift_client_tarball        = var.openshift_client_tarball
    storage_type                    = var.storage_type
    release_image_override          = var.release_image_override
    helpernode_tag                  = var.helpernode_tag
    install_playbook_tag            = var.install_playbook_tag
    log_level                       = var.installer_log_level
    ansible_extra_options           = var.ansible_extra_options
}

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

resource "libvirt_volume" "rhcos_base" {
    name    = "${var.cluster_id}-rhcos-base-vol"
    source  = var.rhcos_image
    pool    = var.storage_pool_name
}

# volumes
resource "libvirt_volume" "bootstrap" {
    name            = "${var.cluster_id}-bootstrap"
    base_volume_id  = libvirt_volume.rhcos_base.id
    pool            = var.storage_pool_name
}
resource "libvirt_volume" "master" {
    count           = var.master["count"]
    name            = "${var.cluster_id}-master-${count.index}"
    base_volume_id  = libvirt_volume.rhcos_base.id
    pool            = var.storage_pool_name
}
resource "libvirt_volume" "worker" {
    count           = var.worker["count"]
    name            = "${var.cluster_id}-worker-${count.index}"
    base_volume_id  = libvirt_volume.rhcos_base.id
    pool            = var.storage_pool_name
}


# hostname-ignitions
data "ignition_file" "b_hostname" {
    overwrite   = true
    mode        = "420" // 0644
    path        = "/etc/hostname"
    content {
        content = <<EOF
bootstrap
EOF
    }
}
data "ignition_file" "m_hostname" {
    count       = var.master["count"]
    overwrite   = true
    mode        = "420" // 0644
    path        = "/etc/hostname"
    content {
    content     = <<EOF
master-${count.index}
EOF
    }
}
data "ignition_file" "w_hostname" {
    count       = var.worker["count"]
    overwrite   = true
    mode        = "420" // 0644
    path        = "/etc/hostname"

    content {
    content     = <<EOF
worker-${count.index}
EOF
    }
}


# ignitions
data "ignition_config" "bootstrap" {
    merge {
        source  = "http://${var.bastion_ip}:8080/ignition/bootstrap.ign"
    }
    files = [
        data.ignition_file.b_hostname.rendered,
    ]
}
data "ignition_config" "master" {
    count       = var.master["count"]
    merge {
        source  = "http://${var.bastion_ip}:8080/ignition/master.ign"
    }
    files       = [
        element(data.ignition_file.m_hostname.*.rendered, count.index),
    ]
}
data "ignition_config" "worker" {
    count       = var.worker["count"]
    merge {
        source  = "http://${var.bastion_ip}:8080/ignition/worker.ign"
    }
    files       = [
        element(data.ignition_file.w_hostname.*.rendered, count.index),
    ]
}


# libvirt_ignition
resource "libvirt_ignition" "bootstrap" {
    name        = "${var.cluster_id}-bootstrap.ign"
    content     = replace(data.ignition_config.bootstrap.rendered, "\"timeouts\":{}", "\"timeouts\":{\"httpTotal\":500}")
    pool        = var.storage_pool_name
}
resource "libvirt_ignition" "master" {
    count       = var.master["count"]
    name        = "${var.cluster_id}-master-${count.index}.ign"
    content     = replace(element(data.ignition_config.master.*.rendered, count.index), "\"timeouts\":{}", "\"timeouts\":{\"httpTotal\":500}")
    pool        = var.storage_pool_name
}
resource "libvirt_ignition" "worker" {
    count       = var.worker["count"]
    name        = "${var.cluster_id}-worker-${count.index}.ign"
    content     = replace(element(data.ignition_config.worker.*.rendered, count.index), "\"timeouts\":{}", "\"timeouts\":{\"httpTotal\":500}")
    pool        = var.storage_pool_name
}


# domains
resource "libvirt_domain" "bootstrap" {
    count   = var.bootstrap["count"] == 0 ? 0 : 1
    name    = "${var.cluster_id}-bootstrap"
    memory  = var.bootstrap.memory
    vcpu    = var.bootstrap.vcpu

    coreos_ignition = libvirt_ignition.bootstrap.id

    disk {
        volume_id = libvirt_volume.bootstrap.id
    }
    console {
        type        = "pty"
        target_port = 0
    }
    cpu = {
        mode = var.cpu_mode
    }
    network_interface {
        network_id  = var.network_id
        hostname    = "bootstrap.${var.cluster_id}.${var.cluster_domain}"
        mac         = var.bootstrap_mac
    }
}

resource "libvirt_domain" "master" {
    count   = var.master["count"]
    name    = "${var.cluster_id}-master-${count.index}"
    memory  = var.master.memory
    vcpu    = var.master.vcpu

    coreos_ignition = libvirt_ignition.master[count.index].id

    disk {
        volume_id = libvirt_volume.master[count.index].id
    }
    console {
        type        = "pty"
        target_port = 0
    }
    cpu = {
        mode = var.cpu_mode
    }
    network_interface {
        network_id  = var.network_id
        hostname    = "master-${count.index}.${var.cluster_id}.${var.cluster_domain}"
        mac         = var.master_macs[count.index]
    }
}

resource "libvirt_domain" "worker" {
    count   = var.worker["count"]
    name    = "${var.cluster_id}-worker-${count.index}"
    memory  = var.worker.memory
    vcpu    = var.worker.vcpu

    coreos_ignition = libvirt_ignition.worker[count.index].id

    disk {
        volume_id = libvirt_volume.worker[count.index].id
    }
    console {
        type        = "pty"
        target_port = 0
    }
    cpu = {
        mode = var.cpu_mode
    }
    network_interface {
        network_id  = var.network_id
        hostname    = "worker-${count.index}.${var.cluster_id}.${var.cluster_domain}"
        mac         = var.worker_macs[count.index]
    }
}

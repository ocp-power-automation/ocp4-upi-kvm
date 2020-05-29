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

locals {
    bastion_ip  = cidrhost(var.network_cidr, 2)
}

resource "libvirt_pool" "storage_pool" {
    name        = var.cluster_id
    type        = "dir"
    path        = "${var.images_path}/${var.cluster_id}"
}

resource "random_integer" "no" {
    min     = 10
    max     = 9999
}

resource "libvirt_network" "network" {
    name        = var.cluster_id
    mode        = "nat"
    bridge      = "virbr${random_integer.no.result}"
    domain      = "${var.cluster_id}.${var.cluster_domain}"
    addresses   = [var.network_cidr]
    autostart   = true
    dhcp {
        enabled = false
    }
    dns {
        local_only = true
        forwarders {
            address = local.bastion_ip
            domain = "${var.cluster_id}.${var.cluster_domain}"
        }
    }
}

resource "libvirt_volume" "bastion" {
    name        = "${var.cluster_id}-bastion-vol"
    source      = var.bastion_image
    pool        = libvirt_pool.storage_pool.name
}

resource "libvirt_domain" "bastion" {
    name        = "${var.cluster_id}-bastion"
    memory      = var.bastion.memory
    vcpu        = var.bastion.vcpu

    disk {
        volume_id = libvirt_volume.bastion.id
    }
    console {
        type        = "pty"
        target_port = 0
    }
    cpu = {
        mode = "host-passthrough"
    }
    network_interface {
        network_id  = libvirt_network.network.id
        hostname    = "${var.cluster_id}-bastion.${var.cluster_domain}"
        addresses   = [local.bastion_ip]
        wait_for_lease  = true
    }
}


resource "null_resource" "bastion_init" {
    depends_on = [libvirt_domain.bastion]
    connection {
        type        = "ssh"
        host        = local.bastion_ip
        user        = var.rhel_username
        private_key = var.private_key
        password    = var.rhel_password
        agent       = var.ssh_agent
        timeout     = "15m"
        bastion_host = var.host_address
    }

    provisioner "remote-exec" {
        inline = [
            "whoami",
            "mkdir -p ~/.ssh"
        ]
    }

    provisioner "file" {
        content = var.private_key
        destination = "~/.ssh/id_rsa"
    }
    provisioner "file" {
        content = var.public_key
        destination = "~/.ssh/id_rsa.pub"
    }

    provisioner "remote-exec" {
        inline = [
            "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys",
            "sudo chmod 600 ~/.ssh/id_rsa* ~/.ssh/authorized_keys",
            "sudo hostnamectl set-hostname --static ${lower(var.cluster_id)}-bastion.${var.cluster_domain}",
            "echo 'HOSTNAME=${lower(var.cluster_id)}-bastion.${var.cluster_domain}' | sudo tee -a /etc/sysconfig/network > /dev/null",
            "sudo hostname -F /etc/hostname"
        ]
    }
    provisioner "remote-exec" {
        inline = [<<EOF
if [ '${var.rhel_subscription_username}' != '' ]
then
    sudo subscription-manager clean
    sudo subscription-manager register --username=${var.rhel_subscription_username} --password=${var.rhel_subscription_password} --force
    sudo subscription-manager refresh
    sudo subscription-manager attach --auto
fi
EOF
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "#sudo dnf update -y --skip-broken",
            "sudo dnf install -y wget jq git net-tools bind-utils vim python3 python3-devel httpd tar",
            "sudo dnf install -y openssl-devel libffi-devel"
        ]
    }
    provisioner "remote-exec" {
        inline = [
            "sudo pip3 install ansible -q"
        ]
    }
}

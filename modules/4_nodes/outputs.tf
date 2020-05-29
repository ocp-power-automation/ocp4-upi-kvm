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

output "bootstrap_ip" {
    value = local.bootstrap_ip
}

output "master_ips" {
    value = null_resource.master_ip.*.triggers.address
}

output "worker_ips" {
    value = null_resource.worker_ip.*.triggers.address
}

output "bootstrap_mac" {
    value = libvirt_domain.bootstrap.network_interface[0].mac
}

output "master_macs" {
    value = flatten(flatten(libvirt_domain.master.*.network_interface).*.mac)
}

output "worker_macs" {
    value = flatten(flatten(libvirt_domain.worker.*.network_interface).*.mac)
}

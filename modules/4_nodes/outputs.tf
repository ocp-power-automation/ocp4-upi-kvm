output "bootstrap_ip" {
    value = libvirt_domain.bootstrap.network_interface[0].addresses[0]
}

output "master_ips" {
    value = flatten(flatten(libvirt_domain.master.*.network_interface).*.addresses)
}

output "worker_ips" {
    value = flatten(flatten(libvirt_domain.worker.*.network_interface).*.addresses)
}

output "bastion_ip" {
    depends_on = [null_resource.bastion_init]
    value = local.bastion_ip
}

output "storage_pool_name" {
    value = libvirt_pool.storage_pool.name
}

output "network_id" {
    value = libvirt_network.network.id
}

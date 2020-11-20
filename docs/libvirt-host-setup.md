# Libvirt Host Setup
<!-- TOC -->

- [Libvirt Host Setup](#libvirt-host-setup)
  - [Libvirt Configuration](#libvirt-configuration)
    - [Install and Configure Libvirt](#install-and-configure-libvirt)
    - [Enable IP Forwarding](#enable-ip-forwarding)
    - [Accept TCP connections](#accept-tcp-connections)
    - [Allow Firewall for libvirt connections](#allow-firewall-for-libvirt-connections)
    - [Password less access](#password-less-access)
    - [Verification](#verification)

<!-- /TOC -->
## Libvirt Configuration

The following steps are required to configure Libvirt to work with the automation code
### Install and Configure Libvirt

Please follow the steps given at [Install and Enable section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#install-and-enable-libvirt)

### Enable IP Forwarding

Please follow the steps given at [IP forwarding section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#enable-ip-forwarding)

### Accept TCP connections

Please follow the steps given at [Accept TCP connections section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#for-permanently-running-libvirt-daemon)

### Allow Firewall for libvirt connections

Please follow the steps given at [Firewalld section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#firewalld)

### Password less access

Follow below steps to add the public key of the Terraform client machine user to the authorized list for password-less access.
1. Copy ~/.ssh/id_rsa.pub contents from Terraform client machine.
2. Append the public key as copied above to ~/.ssh/authorized_keys on the KVM host.

### Verification

You can verify TCP connections to the kvm host using an example `virsh` command given below.
```
virsh --connect qemu+tcp://<host_name_or_ip>/system --readonly
```
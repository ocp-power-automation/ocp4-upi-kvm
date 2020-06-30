# Libvirt Host setup

Follow below references for setting up the KVM host for running the OpenShift cluster. These steps are required to be followed before running the automation.


## Install and Configure Libvirt

Please follow the steps given at [Install and Enable section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#install-and-enable-libvirt)

## Enable IP Forwarding

Please follow the steps given at [IP forwarding section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#enable-ip-forwarding)

## Accept TCP connections

Please follow the steps given at [Accept TCP connections section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#for-permanently-running-libvirt-daemon)

## Allow Firewall for libvirt connections

Please follow the steps given at [Firewalld section](https://github.com/openshift/installer/blob/master/docs/dev/libvirt/README.md#firewalld)

## Password less access

Follow below steps to add the public key of the Terraform client machine user to the authorized list for password-less access.
1. Copy ~/.ssh/id_rsa.pub contents from Terraform client machine.
2. Append the public key as copied above to ~/.ssh/authorized_keys on the KVM host.

## Verificcation

You can verify TCP connections to the kvm host using an example `virsh` command given below.
```
virsh --connect qemu+tcp://<host_name_or_ip>/system --readonly
```

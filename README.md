# **Table of Contents**

- [Introduction](#introduction)
- [Pre-requisites](#pre-requisites)
- [OCP Install](#ocp-install)
- [Post-Install Steps](#post-install-steps)
- [OCP Login Credentials](#ocp-login-credentials)
- [Clean up](#clean-up)


# Introduction
This repo contains Terraform templates to help deployment of OpenShift Container Platform (OCP) 4.x on KVM VMs using
libvirt.

This project leverages the [following ansible playbook](https://github.com/RedHatOfficial/ocp4-helpernode) to setup
helper node (bastion) for OCP deployment.

Run this code from either Mac or Linux (Intel) system.

:heavy_exclamation_mark: *This automation is intended for test/development purposes only and there is no formal support. For issues please open a GitHub issue*

# Pre-requisites
- **Git**: Please refer to the following [link](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for instructions
on installing `git` for Linux and Mac.
- **Terraform**: You'll need to use version `0.12.20`. Please refer to the following [link](https://learn.hashicorp.com/terraform/getting-started/install.html) for instructions on installing `terraform` for Linux and Mac.
- **libvirt**: Please ensure `libvirt` is installed and configured on the KVM host. Enable IP forwarding and configure
libvirt to accept TCP connections for remote installations. Ensure firewall rules allow remote connections to the host.
- **Go**: Please refer to the following [link](https://golang.org/dl/) for instructions on installing `go` for Linux and Mac

## Image and LPAR requirements

RedHat CoreOS (RHCOS) images for Power can be downloaded from [here](https://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/).
Following are the recommended VM configs for OpenShift nodes
- Bootstrap, Master - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_This config is suitable for majority of the scenarios_**
- Worker - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_Increase worker vCPUs, RAM and Disk based on application requirements_**

# OCP Install
Follow these steps to kickstart OCP installation on KVM

## Setup automation
On your Terraform client machine:
1. `git clone https://github.com/ocp-power-automation/ocp4-upi-kvm.git`
2. `cd ocp4_upi_kvm`
3. `go get -u github.com/dmacvicar/terraform-provider-libvirt`

   `cp $GOPATH/bin/terraform-provider-libvirt ~/.terraform.d/plugins/darwin_amd64/`

## Setup required Terraform Variables
Update the var.tfvars file with values specific to your environment. Following is a brief description of the variables.
 * `libvirt_uri` : The connection URI used to connect to the libvirt host.
 * `host_address` : Host address where libvirtd is running. This will be required during remote installation.
 * `images_path` :  Path on the libvirt host where all the images will be stored.
 * `bastion_image` :  Path to RHEL 8.1 image, local(machine running terraform) or remote using HTTP(S) url.
 * `rhcos_image` : Path to RHCOS image, local(machine running terraform) or remote using HTTP(S) url.
 * `bastion` : Map of below parameters for bastion host.
    * `memory` : Memory in MBs required for bastion node.
    * `vcpu` : Number of VCPUs to use for bastion.
 * `bootstrap` : Map of below parameters for bootstrap host.
    * `memory` : Memory in MBs required for bootstrap node.
    * `vcpu` : Number of VCPUs to use for bootstrap node.
    * `count` : Always set the value to 1 before starting the deployment. When the deployment is completed successfully set to 0 to delete the bootstrap node.
 * `master` : Map of below parameters for master hosts.
    * `memory` : Memory in MBs required for master nodes.
    * `vcpu` : Number of VCPUs to use for master  nodes.
    * `count` : Number of master nodes.
 * `worker` : Map of below parameters for worker hosts. (Atleaset 2 Workers are required for running router pods in HA mode)
    * `memory` : Memory in MBs required for worker nodes.
    * `vcpu` : Number of VCPUs to use for worker nodes.
    * `count` : Number of worker nodes.
 * `network_cidr` : Network subnet range for the cluster. Ensure it is unique for each cluster on the same host.
 * `rhel_username` : The user that we should use for the connection to the bastion host.
 * `rhel_password` : The password for above username for the connection to the bastion host initially. Leave empty if ssh-key is already set on bastion_image.
 * `keypair_name` : Optional value for keypair used. Default is <cluster_id>-keypair.
 * `public_key_file` : A pregenerated OpenSSH-formatted public key file. Default path is '~/.ssh/id_rsa.pub'.
 * `private_key_file` : Corresponding private key file. Default path is '~/.ssh/id_rsa'.
 * `private_key` : The contents of an SSH key to use for the connection. Ignored if `public_key_file` is provided.
 * `public_key` : The contents of corresponding key to use for the connection. Ignored if `public_key_file` is provided.
 * `rhel_subscription_username` : The username required for RHEL subcription on bastion host. Leave empty if repos are already set in the bastion_imageyy and subscription is not needed.
 * `rhel_subscription_password` : The password required for RHEL subcription on bastion host.
 * `openshift_install_tarball` : HTTP URL for OpenShift install tarball.
 * `openshift_client_tarball` : HTTP URL for OpenShift client (`oc`) tarball.
 * `release_image_override` : This is set to OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE while creating ignition files.
 * `installer_log_level` : enable log level for openshift-install (e.g. "debug | info | warn | error") (default "info")
 * `ansible_extra_options` : Ansible options to append to the ansible-playbook commands. Default is set to "-v".
 * `helpernode_tag` : [ocp4-helpernode](https://github.com/RedHatOfficial/ocp4-helpernode) ansible playbook version to checkout.
 * `install_playbook_tag` : [ocp4-playbooks](https://github.com/ocp-power-automation/ocp4-playbooks) ansible playbooks version to checkout.
 * `pull_secret_file` : Location of the pull-secret file to be used.
 * `cluster_domain` : Cluster domain name. `<cluster_id>.<cluster_domain>` forms the fully qualified domain name.
 * `cluster_id_prefix` : Cluster identifier. Should not be more than 8 characters. Nodes are pre-fixed with this value, please keep it unique.
 * `dns_forwarders` : External DNS servers to forward DNS queries that cannot resolve locally. Eg: `"8.8.8.8; 9.9.9.9"`.
 * `storage_type` : Storage provisioner to configure. Supported values: nfs (For now only nfs provisioner is supported, any other value won't setup a storageclass)
 * `volume_size` : If storage_type is nfs, a volume will be created with given size in GB and attached to bastion node. Eg: 1000 for 1TB disk.

## Setup required data files
You need to have following files in data/ directory before running the Terraform templates.
```
$ ls data/
id_rsa  id_rsa.pub  pull-secret.txt
```
 * `id_rsa` & `id_rsa.pub` : The key pair used for accessing the hosts. These files are not required if you provide `public_key_file` and `private_key_file`.
 * `pull-secret.txt` : File containing keys required to pull images on the cluster. You can download it from RH portal after login https://cloud.redhat.com/openshift/install/pull-secret.

## Kickstart Install
Run the following from within the `ocp4-upi-kvm`directory:
1. `terraform init`
2. `terraform apply -var-file var.tfvars`

Now wait for the installation to complete. It may take around 40 mins to complete provisioning.

You will get an error if you have not installed 'terraform-provider-libvirt' plugin already. You will need to download and install the plugin on the Terraform terminal before running `terraform init`. For more information on how-to check [here](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/README.md).

**IMPORTANT**: When using NFS storage, the OpenShift image registry will be using NFS PV claim. Otherwise the image registry uses ephemeral PV.

**IMPORTANT**: Once the deployment is completed successfully, you can safely delete the bootstrap node.

# Post Install Steps

## Delete Bootstrap node
1. Change the `count` value to 0 in `bootstrap` map variable and re-run the apply command. Eg: `bootstrap = { memory = 8192, vcpu = 4, count = 0 }`
2. Run command `terraform apply -var-file var.tfvars`


## Create API and Ingress DNS Records
You will also need to add the following records to your DNS server:
```
api.<cluster name>.<cluster domain>.  IN  A  <Bastion IP>
*.apps.<cluster name>.<cluster domain>.  IN  A  <Bastion IP>
```
If you're unable to create and publish these DNS records, you can add them to your /etc/hosts file.
```
<Bastion IP> api.<cluster name>.<cluster domain>
<Bastion IP> console-openshift-console.apps.<cluster name>.<cluster domain>
<Bastion IP> integrated-oauth-server-openshift-authentication.apps.<cluster name>.<cluster domain>
<Bastion IP> oauth-openshift.apps.<cluster name>.<cluster domain>
<Bastion IP> prometheus-k8s-openshift-monitoring.apps.<cluster name>.<cluster domain>
<Bastion IP> grafana-openshift-monitoring.apps.<cluster name>.<cluster domain>
<Bastion IP> <app name>.apps.<cluster name>.<cluster domain>
```

**Note**: For your convenience entries specific to your cluster will be printed at the end of a successful run.
Just copy and paste value of output variable `etc_hosts_entries` to your hosts file.

# OCP Login Credentials
The OCP login credentials are in bastion host. In order to retrieve the same follow these steps:
1. `ssh -i data/id_rsa <rhel_username>@<bastion_ip>`
2. `cd ~/openstack-upi/auth`
3. `kubeconfig` can be used for CLI (`oc` or `kubectl`)
4. `kubeadmin` user and content of `kubeadmin-pasword` as password for GUI


# Clean up
Run `terraform destroy -var-file var.tfvars` to make sure that all resources are properly cleaned up.
Do not manually clean up your environment unless both of the following are true:

1. You know what you are doing
2. Something went wrong with an automated deletion.

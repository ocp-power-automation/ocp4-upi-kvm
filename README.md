# Terraform for OpenShift 4.X on KVM
This repo contains Terraform templates required to deploy OCP 4.X on KVM using libvirt. Terraform resources are implemented by refering to https://github.com/openshift/installer/blob/master/docs/user/openstack/install_upi.md.

Please ensure you have installed and enabled libvirt on the KVM host. Enable IP forwarding and configure libvirt to accept TCP connections for remote installations. Also, check if firewall rules allow remote connections to the host.

This repo uses Ansible playbooks for the installation steps which are executed by the Terraform module. No need to run the playbooks manually.

The Terraform module will setup a private network, storage pool, domains, volumes, etc. using the libvirt provider. Initially bastion node is created using static network address and a DHCP service is used for assigning network addresses for 1 bootstrap, N masters and M workers nodes. The DHCP server will be running on the bastion node along with other services required for the cluster. We make use of [OCP4 Helper Node](https://github.com/RedHatOfficial/ocp4-helpernode) playbook to setup DNS, HAProxy, HTTP and DHCP services on the bastion node.

Run this code from either Mac or Linux (Intel) system.

:heavy_exclamation_mark: *This automation is intended for test/development purposes only and there is no formal support. For issues please open a GitHub issue*

## How-to install Terraform
https://learn.hashicorp.com/terraform/getting-started/install.html

Please follow above link to download and install Terraform on your machine. Here is the download page for your convenience https://www.terraform.io/downloads.html. Ensure you are using Terraform 0.12.20 and above. These modules are tested with the given(latest at this moment) version.

## Image and LPAR requirements

CoreOS images for Power can be downloaded from [here](https://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/).
Following are the recommended LPAR configs for OpenShift nodes
- Bootstrap, Master - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_This config is suitable for majority of the scenarios_**
- Worker - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_Increase worker vCPUs, RAM and Disk based on application requirements_**

## Setup this repo
On your Terraform client machine:
1. Clone this repo
2. `cd ocp4_upi_kvm`

## How-to set Terraform variables
Edit the var.tfvars file with following values:
 * `libvirt_uri` : The connection URI used to connect to the libvirt host.
 * `host_address` : Host address where libvirtd is running. This will be required during remote installation.
 * `images_path` :  Path on the libvirt host where all the images will be stored.
 * `bastion_image` :  Path to RHEL image, local(machine running the terraform) or remote using HTTP(S) url.
 * `rhcos_image` : Path to RHCOS image, local(machine running the terraform) or remote using HTTP(S) url.
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
 * `worker` : Map of below parameters for worker hosts. (Atleaset 2 Workers are required for running router pods)
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
 * `openshift_install_tarball` : HTTP URL for openhift-install tarball.
 * `openshift_client_tarball` : HTTP URL for openhift client (`oc`) tarball.
 * `release_image_override` : This is set to OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE while creating ign files. If you are using internal artifactory then ensure that you have added auth key to pull-secret.txt file.
 * `installer_log_level` : enable log level for openshift-install (e.g. "debug | info | warn | error") (default "info")
 * `ansible_extra_options` : Ansible options to append to the ansible-playbook commands. Default is set to "-v".
 * `helpernode_tag` : Checkout level for [ocp4-helpernode](https://github.com/RedHatOfficial/ocp4-helpernode) which is used for setting up services required on bastion node.
 * `pull_secret_file` : Location of the pull-secret file to be used.
 * `cluster_domain` : Cluster domain name. cluster_id.cluster_domain together form the fully qualified domain name.
 * `cluster_id_prefix` : Cluster identifier. Should not be more than 8 characters. Nodes are pre-fixed with this value, please keep it unique (may be with your name).
 * `dns_forwarders` : External DNS servers to forward DNS queries that cannot resolve locally. Eg: `"8.8.8.8; 9.9.9.9"`.
 * `storage_type` : Storage provisioner to configure. Supported values: nfs (For now only nfs provisioner is supported, any other value won't setup a storageclass)
 * `volume_size` : If storage_type is nfs, a volume will be created with given size in GB and attached to bastion node. Eg: 1000 for 1TB disk.


## How-to run Terraform resources
On your Terraform client machine:
1. `cd ocp4_upi_kvm`
1. `terraform init`
1. `terraform apply -var-file var.tfvars`

Now wait for the installation to complete. It may take around 40 mins to complete provisioning.

You will get an error if you have not installed 'terraform-provider-libvirt' plugin already. You will need to download and install the plugin on the Terraform terminal before running `terraform init`. For more information on how-to check [here](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/README.md).

**IMPORTANT**: When using NFS storage, the OpenShift image registry will be using NFS PV claim. Otherwise the image registry uses ephemeral PV.

**IMPORTANT**: Once the deployment is completed successfully, you can safely delete the bootstrap node. After this, the HAPROXY server will not point to the APIs from bootstrap node once the cluster is up and running. Clients will start consuming APIs from master nodes once the bootstrap node is deleted. Take backup of all the required files from bootstrap node (eg: logs) before running below steps.

To delete the bootstrap node:
1. Change the `count` value to 0 in `bootstrap` map variable and re-run the apply command. Eg: `bootstrap = { memory = 8192, vcpu = 4, count = 0 }`
2. Run command `terraform apply -var-file var.tfvars`


## Create API and Ingress DNS Records
You will also need to add the following records to your DNS:
```
api.<cluster name>.<base domain>.  IN  A  <Bastion IP>
*.apps.<cluster name>.<base domain>.  IN  A  <Bastion IP>
```
If you're unable to create and publish these DNS records, you can add them to your /etc/hosts file.
```
<Bastion IP> api.<cluster name>.<base domain>
<Bastion IP> console-openshift-console.apps.<cluster name>.<base domain>
<Bastion IP> integrated-oauth-server-openshift-authentication.apps.<cluster name>.<base domain>
<Bastion IP> oauth-openshift.apps.<cluster name>.<base domain>
<Bastion IP> prometheus-k8s-openshift-monitoring.apps.<cluster name>.<base domain>
<Bastion IP> grafana-openshift-monitoring.apps.<cluster name>.<base domain>
<Bastion IP> <app name>.apps.<cluster name>.<base domain>
```

Hint: For your convenience entries specific to your cluster will be printed at the end of a successful run. Just copy and paste value of output variable `etc_hosts_entries` to your hosts file.

## OCP login credentials for CLI and GUI
The OCP login credentials are in bastion host. In order to retrieve the same follow these steps:
1. `ssh root@<bastion_ip>`
2. `cd ~/openstack-upi/auth`
3. `kubeconfig` can be used for CLI (`oc` or `kubectl`)
4. `kubeadmin` user and content of `kubeadmin-pasword` as password for GUI
 

## Cleaning up
Run `terraform destroy -var-file var.tfvars` to make sure that all resources are properly cleaned up. Do not manually clean up your environment unless both of the following are true:

1. You know what you are doing
2. Something went wrong with an automated deletion.

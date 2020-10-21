# Installation Quickstart

- [Setup Repository](#setup-repository)
- [Setup Variables](#setup-variables)
- [Setup Data Files](#setup-data-files)
- [Start Install](#start-install)
- [Post Install](#post-install)
- [Cluster Access](#cluster-access)
- [Clean up](#clean-up)


## Setup Repository
Clone this git repository on the client machine:
```
git clone https://github.com/ocp-power-automation/ocp4-upi-kvm.git
cd ocp4_upi_kvm
```

**NOTE**: Please checkout a [release branch](https://github.com/ocp-power-automation/ocp4-upi-kvm/branches) eg. `release-4.5` for deploying a specific OCP release. The `master` branch will contain the latest changes which may not work with stable OCP releases but might work with pre-release OCP versions. You can also checkout stable [release tags](https://github.com/ocp-power-automation/ocp4-upi-kvm/releases) eg. `v4.3` for deploying a stable OCP releases.

To checkout specific release branch or tag please run:
```
$ git checkout <branch|tag name>
```

## Setup Variables
Update the var.tfvars with values explained in the following sections. You can also set the variables using other ways mentioned [here](https://www.terraform.io/docs/configuration/variables.html#assigning-values-to-root-module-variables) such as -var option or environment variables.

### Setup Libvirt Host Variables

Update the following variables specific to your environment.

 * `libvirt_uri` : (Required) The connection URI used to connect to the libvirt host.
 * `host_address` : (Required) Host address where libvirtd is running. This will be required during remote installation.
 * `images_path` : (Optional) Path on the libvirt host where all the images will be stored. Default is set '/home/libvirt/openshift-images'.

### Setup Nodes Variables

Update the following variables specific to your cluster requirement. All the variables are required to be specified.

 * `bastion_image` :  Path to RHEL 8.X image, local(machine running terraform) or remote using HTTP(S) url.
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

### Setup Intrumentation Variables

Update the following variables specific to the nodes.

 * `cpu_mode` : (Optional) Guest CPU mode value. Eg: custom, host-passthrough, host-model.
 * `network_cidr` : (Optional) Network subnet range for the cluster. Ensure it is unique for each cluster on the same host. Default is set to '192.168.27.0/24'.
 * `rhel_username` : (Optional) The user that we should use for the connection to the bastion host. Default is set to 'root'.
 * `rhel_password` : (Optional) The password for above username for the connection to the bastion host initially. Leave empty if ssh-key is already set on bastion_image.
 * `keypair_name` : (Optional) Value for keypair used. Default is <cluster_id>-keypair.
 * `public_key_file` : (Optional) A pregenerated OpenSSH-formatted public key file. Default path is '~/.ssh/id_rsa.pub'.
 * `private_key_file` : (Optional) Corresponding private key file. Default path is '~/.ssh/id_rsa'.
 * `private_key` : (Optional) The contents of an SSH key to use for the connection. Ignored if `public_key_file` is provided.
 * `public_key` :(Optional) The contents of corresponding key to use for the connection. Ignored if `public_key_file` is provided.
 * `rhel_subscription_username` : (Optional) The username required for RHEL subcription on bastion host. Leave empty if repos are already set in the bastion_image and subscription is not needed.
 * `rhel_subscription_password` : (Optional) The password required for RHEL subcription on bastion host.
 * `rhel_subscription_org` : (Optional) The organization to use for RHEL subscription if username/password is unsuitable
 * `rhel_subscription_activationkey` : (Optional) The activation key to use in conjunction with an organization

### Setup OpenShift Variables

Update the following variables specific to OCP.

 * `openshift_install_tarball` : (Required) HTTP URL for OpenShift install tarball.
 * `openshift_client_tarball` : (Required) HTTP URL for OpenShift client (`oc`) tarball.
 * `cluster_domain` : (Required) Cluster domain name. `<cluster_id>.<cluster_domain>` forms the fully qualified domain name.
 * `cluster_id_prefix` : (Required) Cluster identifier prefix. Should not be more than 8 characters. Nodes are pre-fixed with this value, please keep it unique.
 * `cluster_id` : (Optional) Cluster identifier, when not set random value will be used. Length cannot exceed 14 characters when combined with cluster_id_prefix.
 * `release_image_override` : (Optional) This is set to OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE while creating ignition files.
 * `installer_log_level` : (Optional) Log level for openshift-install (e.g. "debug | info | warn | error") (default "info")
 * `ansible_extra_options` : (Optional) Ansible options to append to the ansible-playbook commands. Default is set to "-v".
 * `helpernode_tag` : (Optional) [ocp4-helpernode](https://github.com/RedHatOfficial/ocp4-helpernode) ansible playbook version to checkout.
 * `install_playbook_tag` : (Optional) [ocp4-playbooks](https://github.com/ocp-power-automation/ocp4-playbooks) ansible playbooks version to checkout.
 * `pull_secret_file` : (Optional) Location of the pull-secret file to be used. Default path is 'data/pull-secret.txt'.
 * `dns_forwarders` : (Optional) External DNS servers to forward DNS queries that cannot resolve locally. Eg: `"8.8.8.8; 9.9.9.9"`.
 * `chrony_config`: (Optional) Whether to enable NTP via chronyd. Default: true
 * `chrony_config_servers`: (Optional) NTP servers to use with chrony, e.g. `[{server: "ntp.example.com", options: "iburst"}]`. The default value is `[]`, which uses chronyd's default servers.

### Setup Storage Variables

Update the following variables specific to OCP storage. Note that currently only NFS storage provisioner is supported.

 * `storage_type` : Storage provisioner to configure. Supported values: nfs (For now only nfs provisioner is supported, any other value won't setup a storageclass)
 * `volume_size` : If storage_type is nfs, a volume will be created with given size in GB and attached to bastion node. Eg: 1000 for 1TB disk.

### Setup OCP Upgrade Variables

Update the following variables specific to OCP upgrade. The upgrade will be performed after a successful install of OCP.

 * `upgrade_version` : (Optional) OpenShift higher and supported version. If set, OCP cluster will be upgraded to this version. (e.g. `"4.5.4"`)
 * `upgrade_channel` : (Optional) OpenShift channel having required upgrade version available for cluster upgrade. By default it is automatically set to stable channel of installed cluster (eg: stable-4.5). See [Understanding Upgrade Channels](https://docs.openshift.com/container-platform/4.5/updating/updating-cluster-between-minor.html#understanding-upgrade-channels_updating-cluster-between-minor) for more information on setting the upgrade channel.
 * `upgrade_pause_time` : (Optional) Minutes to pause the playbook execution before starting to check the upgrade status once the upgrade command is executed.
 * `upgrade_delay_time` : (Optional) Seconds to wait before re-checking the upgrade status once the playbook execution resumes.

## Setup Data Files
You need to have following files in data/ directory before running the Terraform templates.
```
$ ls data/
id_rsa  id_rsa.pub  pull-secret.txt
```
 * `id_rsa` & `id_rsa.pub` : The key pair used for accessing the hosts. These files are not required if you provide `public_key_file` and `private_key_file`.
 * `pull-secret.txt` : File containing keys required to pull images on the cluster. You can download it from RH portal after login https://cloud.redhat.com/openshift/install/pull-secret.

## Start Install

Run the following commands from where you have cloned this repository:

```
terraform init
terraform apply -var-file var.tfvars
```

Now wait for the installation to complete. It may take around 40 mins to complete provisioning.

You will get an error if you have not installed 'terraform-provider-libvirt' plugin already. You will need to download and install the plugin on the Terraform terminal before running `terraform init`. For more information on how-to check [here](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/README.md).

**IMPORTANT**: When using NFS storage, the OpenShift image registry will be using NFS PV claim. Otherwise the image registry uses ephemeral PV.

## Post Install

### Delete Bootstrap Node

Once the deployment is completed successfully, you can safely delete the bootstrap node. This step is optional but recommended to free up the used resources during install.

1. Change the `count` value to 0 in `bootstrap` map variable and re-run the apply command. Eg: `bootstrap = { memory = 8192, vcpu = 4, count = 0 }`
2. Run command `terraform apply -var-file var.tfvars`

### Create API and Ingress DNS Records
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

## Cluster Access

The OCP login credentials are in bastion host. To retrieve the same follow these steps:
1. `ssh -i data/id_rsa <rhel_username>@<bastion_ip>`
2. `cd ~/openstack-upi/auth`
3. `kubeconfig` can be used for CLI (`oc` or `kubectl`)
4. `kubeadmin` user and content of `kubeadmin-password` as password for GUI


The OpenShift web console URL will be printed with output variable `web_console_url` (eg. https://console-openshift-console.apps.test-ocp-090e.rhocp.com) on successful run. Open this URL on your browser and login with user `kubeadmin` and password as retrieved above.

The OpenShift command-line client is already configured on the bastion node with kubeconfig placed at `~/.kube/config`. Just start using the oc client directly.

## Clean up

To destroy after you are done using the cluster you can run command `terraform destroy -var-file var.tfvars` to make sure that all resources are properly cleaned up.
Do not manually clean up your environment unless both of the following are true:

1. You know what you are doing
2. Something went wrong with an automated deletion.

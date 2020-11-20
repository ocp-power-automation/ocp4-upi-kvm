# Automation Host Prerequisites

<!-- TOC -->

- [Automation Host Prerequisites](#automation-host-prerequisites)
  - [Configure Your Firewall](#configure-your-firewall)
  - [Automation Host Setup](#automation-host-setup)
    - [Terraform](#terraform)
    - [Terraform Providers](#terraform-providers)
    - [Git](#git)
    - [RHCOS and RHEL 8.X Images for OpenShift](#rhcos-and-rhel-8x-images-for-openshift)
      - [Download the RHEL Qcow2 image](#download-the-rhel-qcow2-image)
        - [Customize the RHEL Qcow2 image](#customize-the-rhel-qcow2-image)
      - [Download the RHCOS Qcow2 image](#download-the-rhcos-qcow2-image)

<!-- /TOC -->

## Configure Your Firewall

If your automation host is behind a firewall, you will need to ensure the following ports are open in order to use ssh, http, and https:
- 22, 443, 80

These additional ports are required for the ocp cli (`oc`) post-install:
- 6443

## Automation Host Setup

Install the following packages on the automation host. Select the appropriate install binaries based on your automation host platform - Mac/Linux.
It's preferable to run this automation code on Linux host since Linux is required for customizing the RHEL image.

### Terraform

**Terraform >= 0.13.0**: Please refer to the [link](https://learn.hashicorp.com/terraform/getting-started/install.html) for instructions on installing Terraform. For validating the version run `terraform version` command after install.

**Terraform** binary on IBM Power (`ppc64le`) is not available for download from Hashicorp website.
You can download it from the following [link-1](https://www.power-devops.com/terraform) or [link-2](https://oplab9.parqtec.unicamp.br/pub/ppc64el/terraform/) or you will need to compile it from source by running:

```
TAG_VERSION=v0.13.5
git clone https://github.com/hashicorp/terraform --branch $TAG $GOPATH/src/github.com/hashicorp/terraform
cd $GOPATH/src/github.com/hashicorp/terraform
TF_DEV=1 scripts/build.sh
```

Validate using:
```
$GOPATH/bin/terraform version
```

### Terraform Providers

Please follow the [guide](./terraform-provider-build.md) to build and install the required Terraform providers.

### Git

**Git**:  Please refer to the [link](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for instructions on installing Git.

### RHCOS and RHEL 8.X Images for OpenShift

You'll need to have the RedHat CoreOS (RHCOS) and RHEL 8.2 (or later) image available on the automation host or via an HTTP(S) server.
RHEL 8.x image is used by bastion node, and RHCOS image is used for boostrap, master and worker nodes.

#### Download the RHEL Qcow2 image

- Login to the RedHat portal and click on the [Downloads](https://access.redhat.com/downloads) tab.
- Click on the product [Red Hat Enterprise Linux 8](https://access.redhat.com/downloads/content/479/) from the list.
- In the "Product Variant" drop-down select "Red Hat Enterprise Linux for Power, little endian".
- In the "Version" drop-down select the version of RHEL you want to download. For example, will use the latest as 8.2.
- In the "Product Software" tab, click on "Download Now" button adjacent to "Red Hat Enterprise Linux 8.2 Update KVM Guest Image".
- Save the Qcow2 image.
- If your automation host is not Linux, then you will need to copy the Qcow2 image to a Linux host for the next step.

##### Customize the RHEL Qcow2 image

Customize the Qcow2 image to set a root password and disable the cloud-init service.
You will need the 'libguestfs-tools' package installed on the Linux machine to run the below command (Not available on Mac/Windows).

```
# virt-customize -a <qcow2 image file name> --root-password password:<password> --uninstall cloud-init
[   0.0] Examining the guest ...
[  11.5] Setting a random seed
[  11.5] Uninstalling packages: cloud-init
[  13.9] Setting passwords
[  15.6] Finishing off
```

On successful completion, copy the image back to the automation host (if it was not Linux) or make it available via an HTTP(S) server.

Update the following Terraform input variables:
 * `rhel_password = "<password>"`



#### Download the RHCOS Qcow2 image

- Select the RHCOS version you need from the [OpenShift mirror](http://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/).
- Find and download the QEMU qcow2 image gzip file. eg: rhcos-4.4.9-ppc64le-qemu.ppc64le.qcow2.gz
- Extract the Qcow2 image and place it on the automation host or make it available via an HTTP(S) server.

# Preparing Images for Power

The automation uses QCOW2 images which is a storage format for virtual disks. The Red Hat Enterprise Linux QCOW2 images are for use with Red Hat Enterprise Linux KVM hypervisors. You can access the RHEL 8 images download page from [Red Hat Customer Portal](https://access.redhat.com/).

## Download the RHEL qcow2 image
- Login to the RedHat portal and click on the [Downloads](https://access.redhat.com/downloads) tab.
- Click on the product [Red Hat Enterprise Linux 8](https://access.redhat.com/downloads/content/479/) from the list.
- In the "Product Variant" drop-down select "Red Hat Enterprise Linux for Power, little endian".
- In the "Version" drop-down select the version of RHEL you want to download. For example, will use the latest as 8.2.
- In the "Product Software" tab, click on "Download Now" button adjacent to "Red Hat Enterprise Linux 8.2 Update KVM Guest Image".
- Save the qcow2 image on your machine, place it at a specific location.

## Customize the RHEL qcow2 image
For using RHEL in a KVM/QEMU hypervisor, one must set a root password and disable the cloud-init service.
You will need the 'libguestfs-tools' package installed on the Linux machine to run the below command (Not available on Mac/Windows).

```
# virt-customize -a <qcow2 image file name> --root-password password:<password> --uninstall cloud-init
[   0.0] Examining the guest ...
[  11.5] Setting a random seed
[  11.5] Uninstalling packages: cloud-init
[  13.9] Setting passwords
[  15.6] Finishing off
```

Update the following Terraform input variables:
 * `rhel_password = "<password>"`

## Download the RHCOS qcow2 image

- Select the RHCOS version you need from the [OpenShift mirror](http://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/).
- Find and download the QEMU qcow2 image gzip file. eg: rhcos-4.4.9-ppc64le-qemu.ppc64le.qcow2.gz
- Extract the qcow2 image and place it at a specific location.

## Use in automation
Update the following Terraform input variables:
 * `bastion_image = "<RHEL image(qcow2) path/url>"`
 * `rhcos_image =  "<RHCOS image(qcow2) path/url>"`

You can either provide the system file path OR HTTP(S) location as inputs to above variables. This is relative to the machine where you are running the Terraform. The terraform client will copy over the files to the KVM host for creating libvirt volumes.

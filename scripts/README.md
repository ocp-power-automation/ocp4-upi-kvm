# Purpose

Provide scripts enabling the automation of OCP cluster creation.  Parameters
related to the definition of the cluster such as the OpenShift Version and 
the number and size of worker nodes are specified via environment variables.
The goal is to provide a framework for the development and validation of 
OpenShift clusters and operators such as OpenShift Container Storage.

## Scripts provided

- setup_kvm_host.sh
- create_cluster.sh
- virsh-cleanup.sh

The script setup_kvm_host.sh installs libvirt and haproxy in the host server
enabling OpenShift clusters to be created.  This script is run once.

The script create_cluster.sh creates an OpenShift cluster at a given OCP version
with the designated number of worker nodes in virtual machines. This
scripts supports OCP versions 4.4, 4.5, and 4.6.

The script virsh-cleanup.sh destroy a cluster by removing all virsh objects
related to the cluster.  Only one cluster is supported per host server.

## Required Environment Variables for Cluster Creation

- RHID_USERNAME=xxx
- RHID_PASSWORD=yyy

The bastion image should be placed in the user's home directory.  This image
should be prepared as per  

## Required Files for Cluster Creation

- ~/.ssh/id_rsa
- ~/.ssh/id_rsa.pub
- ~/pull-secret.txt
- ~/$BASTION_IMAGE

The bastion image is a prepared image downloaded from the Redhat Customer Portal following these
[instructions](https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/docs/prepare-images.md).
It is named by the environment variable BASTION_IMAGE which has a default
value of "rhel-8.2-update-2-ppc64le-kvm.qcow2".  This is the name of the file downloaded
from the RedHat website.  To date, three images have been published.  The one shown above is
latest.

## Optional Environment Variables with Default Values for Cluster Creation

- BASTION_IMAGE=${BASTION_IMAGE:="rhel-8.2-update-2-ppc64le-kvm.qcow2"}
- OCP_VERSION=${OCP_VERSION:="4.4"}
- CLUSTER_DOMAIN=${CLUSTER_DOMAIN:="tt.testing"}
- MASTER_DESIRED_CPU=${MASTER_DESIRED_CPU:="4"}
- MASTER_DESIRED_MEM=${MASTER_DESIRED_MEM:="16384"}
- WORKER_DESIRED_CPU=${WORKER_DESIRED_CPU:="4"}
- WORKER_DESIRED_MEM=${WORKER_DESIRED_MEM:="16384"}
- WORKERS=${WORKERS:=2}
- IMAGES_PATH=${IMAGES_PATH:="/var/lib/libvirt/images"}
- OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=${OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=""}

Set a new value like this:
```
export OCP_VERSION=4.5
```

The environment variable OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE is defined by
Redhat.  It instructs the openshift installer to use specific images, because the
installer by default uses the latest available image.  The create script sets
this environment when you specify OCP versions 4.4 and 4.5.  You should set this
environment when specifying OCP 4.6. 

## Example usage for OpenShift Container Storage

```
# Place required files: id_rsa, id_rsa.pub, pull-secret.txt, and bastion image

git clone https://github.com/ocp-power-automation/ocp4-upi-kvm.git
cd ocp4-upi-kvm

./scripts/setup_kvm_host.sh

export RHID_USERNAME=xxx
export RHID_PASSWORD=yyy
export OCP_VERSION=4.5
export WORKER_DESIRED_CPU=16
export WORKER_DESIRED_MEM=65536
export WORKERS=5

./scripts/create_cluster.sh
```

## Cluster output parameters

You should see something like this:
```
Outputs:

bastion_ip = 192.168.88.2
bastion_ssh_command = ssh root@192.168.88.2
bootstrap_ip = 192.168.88.3
cluster_id = test-92c4
etc_hosts_entries = 
192.168.88.2 api.test-92c4.tt.testing console-openshift-console.apps.test-92c4.tt.testing integrated-oauth-server-openshift-authentication.apps.test-92c4.tt.testing oauth-openshift.apps.test-92c4.tt.testing prometheus-k8s-openshift-monitoring.apps.test-92c4.tt.testing grafana-openshift-monitoring.apps.test-92c4.tt.testing example.apps.test-92c4.tt.testing

install_status = COMPLETED
master_ips = [
  "192.168.88.4",
  "192.168.88.5",
  "192.168.88.6",
]
oc_server_url = https://api.test-92c4.tt.testing:6443/
storageclass_name = nfs-storage-provisioner
web_console_url = https://console-openshift-console.apps.test-92c4.tt.testing
worker_ips = [
  "192.168.88.11",
  "192.168.88.12",
  "192.168.88.13",
  "192.168.88.14",
  "192.168.88.15",
]
```

## Post install

The following commands enable you to invoke 'oc' commands in the host KVM server.
```
scp root@192.168.88.2:/usr/local/bin/oc /usr/local/bin
scp -r root@192.168.88.2:openstack-upi .
export KUBECONFIG=~/openstack-upi/auth/kubeconfig
```

## Webconsole Support

Using the example above, on the remote server where you intend to use Firefox or Safari,
add the following to your /etc/hosts file or MacOS equivalent.
```
<ip kvm host server> console-openshift-console.apps.test-92c4.tt.testing oauth-openshift.apps.test-92c4.tt.testing
```
The browser should prompt you to login to the OCP cluster.  The user name is kubeadmin and
the password is located in the file ~/openstack-upi/auth/kubeadmin-password on the KVM host server.

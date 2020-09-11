#!/bin/bash

set +x
export RHID_PASSWORD=${RHID_PASSWORD:=''}
set -x

export RHID_USERNAME=${RHID_USERNAME:=""}

export OCP_VERSION=${OCP_VERSION:="4.4"}

export CLUSTER_DOMAIN=${CLUSTER_DOMAIN:="tt.testing"}

export MASTER_DESIRED_CPU=${MASTER_DESIRED_CPU:="4"}
export MASTER_DESIRED_MEM=${MASTER_DESIRED_MEM:="16384"}

export WORKERS=${WORKERS:=2}

export WORKER_DESIRED_CPU=${WORKER_DESIRED_CPU:="4"}
export WORKER_DESIRED_MEM=${WORKER_DESIRED_MEM:="16384"}

export DATA_DISK_SIZE=${DATA_DISK_SIZE:=100}		# in GBs
export BOOT_DISK_SIZE=${BOOT_DISK_SIZE:=32}		# in GBs

# This is set to the file system with the most space.  Sometimes /home/libvirt/images

export IMAGES_PATH=${IMAGES_PATH:="/var/lib/libvirt/images"}

# This image is obtained from RedHat Customer Portal and then prepared for use

export BASTION_IMAGE=${BASTION_IMAGE:="rhel-8.2-update-2-ppc64le-kvm.qcow2"}

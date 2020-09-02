# **Table of Contents**

- [Introduction](#introduction)
- [Pre-requisites](#pre-requisites)
- [Image and VM requirements](#image-and-vm-requirements)
- [OCP Install](#ocp-install)
- [Contributing](#contributing)


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
- **Terraform >= 0.12.2, < 0.13**: Please refer to the following [link](https://learn.hashicorp.com/terraform/getting-started/install.html) for instructions on installing `terraform` for Linux and Mac.
- **Terraform Providers**: Please ensure terraform providers are built and installed on Terraform Client Machine. You can follow the [Build Terraform Providers](docs/terraform-provider-build.md) guide.
- **libvirt**: Please ensure `libvirt` is installed and configured on the KVM host. You can follow the [Libvirt Host setup](docs/libvirt-host-setup.md) guide.


# Image and VM requirements

For information on how to configure the images required for the automation see [Preparing Images for Power](docs/prepare-images.md).

Following are the recommended VM configs for OpenShift nodes that will be deployed with RHCOS image.
- Bootstrap, Master - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_This config is suitable for majority of the scenarios_**
- Worker - 4 vCPUs, 16GB RAM, 120 GB Disk

   **_Increase worker vCPUs, RAM and Disk based on application requirements_**

Following is the recommended VM config for the helper node that will be deployed with RHEL 8.0 (or later) image.
- Helper node (bastion) - 2vCPUs, 16GB RAM, 200 GB Disk

# OCP Install

Follow these [quickstart](docs/quickstart.md) steps to kickstart OCP installation on Power KVM using libvirt.

# Contributing
Please see the [contributing doc](https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/CONTRIBUTING.md) for more details.
PRs are most welcome !!

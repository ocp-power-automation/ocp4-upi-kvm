# **Table of Contents**

- [**Table of Contents**](#table-of-contents)
- [Introduction](#introduction)
  - [Automation Host Prerequisites](#automation-host-prerequisites)
  - [Libvirt Prerequisites](#libvirt-prerequisites)
  - [OCP Install](#ocp-install)
  - [Contributing](#contributing)


# Introduction

The `ocp4-upi-kvm` [project](https://github.com/ocp-power-automation/ocp4-upi-kvm) provides Terraform based automation code to help the deployment of OpenShift Container Platform (OCP) 4.x on KVM VMs using libvirt.

This project leverages the [following ansible playbook](https://github.com/RedHatOfficial/ocp4-helpernode) to setup a
helper node (bastion) for OCP deployment.


:heavy_exclamation_mark: *For bugs/enhancement requests etc. please open a GitHub [issue](https://github.com/ocp-power-automation/ocp4-upi-kvm/issues)*

:information_source: **The [main](https://github.com/ocp-power-automation/ocp4-upi-kvm/tree/master) branch must be used with latest OCP pre-release versions only. For stable releases please checkout specific release branches -
{[release-4.5](https://github.com/ocp-power-automation/ocp4-upi-kvm/tree/release-4.5), [release-4.6](https://github.com/ocp-power-automation/ocp4-upi-kvm/tree/release-4.6) ...} and follow the docs in the specific release branches.**

## Automation Host Prerequisites

The automation needs to run from a system with internet access. This could be your laptop or a VM with public internet connectivity. This automation code has been tested on the following 64-bit Operating Systems:
- Linux (**preferred**)
- Mac OSX (Darwin)


Follow the [guide](docs/automation_host_prereqs.md) to complete the prerequisites.

## Libvirt Prerequisites

Follow the [guide](docs/libvirt-host-setup.md) to complete the Libvirt prerequisites.
## OCP Install

Follow the [quickstart](docs/quickstart.md) guide for OCP installation on KVM using libvirt.

## Contributing

Please see the [contributing doc](https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/CONTRIBUTING.md) for more details.
PRs are most welcome !!

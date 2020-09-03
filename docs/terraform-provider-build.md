# Steps to build terraform providers

Follow below steps based on your Terraform Client Machine Architecture to setup terraform providers. These steps are required to be followed before running the automation.

## On Mac/Linux
Install latest go from https://golang.org/dl/ and set your GOPATH

```
git clone https://github.com/dmacvicar/terraform-provider-libvirt $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
make install
mkdir -p ~/.terraform.d/plugins/
cp $GOPATH/bin/terraform-provider-libvirt ~/.terraform.d/plugins/terraform-provider-libvirt
```


## On IBM Power Systems
Download Terraform for IBM Power Systems from https://www.power-devops.com/terraform

Install latest go from https://golang.org/dl/ and set your GOPATH

```
mkdir -p ~/.terraform.d/plugins/
```

**terraform-provider-libvirt**: Please refer to the section below for instructions on installing the libvirt provider plugin. For [more information](https://github.com/dmacvicar/terraform-provider-libvirt#building-from-source).
```
git clone https://github.com/dmacvicar/terraform-provider-libvirt $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
make install
cp $GOPATH/bin/terraform-provider-libvirt ~/.terraform.d/plugins/terraform-provider-libvirt
```

**terraform-provider-random >=2.3, <3.0**: Please refer to the section below for instructions on installing the random provider plugin. For [more information](https://github.com/hashicorp/terraform-provider-random#building-the-provider).
```
git clone --branch <TAG> https://github.com/terraform-providers/terraform-provider-random $GOPATH/src/github.com/terraform-providers/terraform-provider-random
cd $GOPATH/src/github.com/terraform-providers/terraform-provider-random
make build
cp $GOPATH/bin/terraform-provider-random ~/.terraform.d/plugins/terraform-provider-random_<TAG>

Note: Set <TAG> to compatible version eg. v2.3.0
```

**terraform-provider-ignition >=1.2, <2.0**: Please refer to the section below for instructions on installing the ignition provider plugin. For [more information](https://github.com/terraform-providers/terraform-provider-ignition#building-the-provider).
```
git clone --branch <TAG> https://github.com/terraform-providers/terraform-provider-ignition $GOPATH/src/github.com/terraform-providers/terraform-provider-ignition
cd $GOPATH/src/github.com/terraform-providers/terraform-provider-ignition
make build
cp $GOPATH/bin/terraform-provider-ignition ~/.terraform.d/plugins/terraform-provider-ignition_<TAG>

Note: Set <TAG> to compatible version eg. v1.2.1
```

**terraform-provider-null >=2.1, <3.0**: Please refer to the section below for instructions on installing the null provider plugin. For [more information](https://github.com/hashicorp/terraform-provider-null#building-the-provider).
```
git clone --branch <TAG> https://github.com/terraform-providers/terraform-provider-null $GOPATH/src/github.com/terraform-providers/terraform-provider-null
cd $GOPATH/src/github.com/terraform-providers/terraform-provider-null
make build
cp $GOPATH/bin/terraform-provider-null ~/.terraform.d/plugins/terraform-provider-null_<TAG>

Note: Set <TAG> to compatible version eg. v2.1.2
```

Upon successful completion. Please follow the instructions outlined here
https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/docs/quickstart.md#start-install


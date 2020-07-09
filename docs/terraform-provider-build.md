# Steps to build terraform providers

Follow below steps based on your Terraform Client Machine Architecture to setup terraform providers. These steps are required to be followed before running the automation.

## On Mac/Linux
Install latest go from https://golang.org/dl/ and set your GOPATH

```
go get -u github.com/dmacvicar/terraform-provider-libvirt
cd $GOPATH/bin/ ; mkdir -p ~/.terraform.d/plugins/; 
cp * ~/.terraform.d/plugins/

```


## On IBM Power Systems
Download Terraform for IBM Power Systems from https://www.power-devops.com/terraform

Install latest go from https://golang.org/dl/ and set your GOPATH

```
go get -u github.com/dmacvicar/terraform-provider-libvirt
go get -u github.com/terraform-providers/terraform-provider-random
go get -u github.com/terraform-providers/terraform-provider-ignition
go get -u github.com/terraform-providers/terraform-provider-null
cd $GOPATH/bin/ ; mkdir -p ~/.terraform.d/plugins/; 
cp * ~/.terraform.d/plugins/
```

Upon successful completion. Please follow the instructions outlined here
https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/docs/quickstart.md#start-install

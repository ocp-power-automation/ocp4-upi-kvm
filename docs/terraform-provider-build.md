# Terraform Providers

At present Terraform registry does not support some plugins. Third-party providers can be manually installed using [local filesystem as a mirror](https://www.terraform.io/docs/commands/cli-config.html#filesystem_mirror). This is in additon to the provider plugins that are downloaded by Terraform during `terraform init`.

Follow below steps based on your Terraform client machine to setup terraform providers. These steps are required to be followed before running the automation.

Most of the steps require Go to be installed from https://golang.org/dl/. We recommed Go version above 1.14. Make sure to set your GOPATH environment variable and add $GOPATH/bin to PATH.

## On Mac/Linux

Identify your platform. All example commands assume Linux as a platform:

> Linux: linux_amd64

> Mac OSX: darwin_amd64

Identify your Terraform plugin directory. You will need to create the directory on your client machine:

> Linux: ~/.local/share/terraform/plugins OR /usr/local/share/terraform/plugins OR /usr/share/terraform/plugins.

> Mac OSX: ~/Library/Application Support/io.terraform/plugins OR /Library/Application Support/io.terraform/plugins


**Libvirt provider**: Please refer to the section below for instructions on installing the libvirt provider plugin. For [more information](https://github.com/dmacvicar/terraform-provider-libvirt#building-from-source).

Run below commands to install libvirt provider. Make sure to change `PLATFORM` and `PLUGIN_PATH` values based on your client machine.

```
PLATFORM=linux_amd64
PLUGIN_PATH=~/.local/share/terraform/plugins

#Install the Libvirt provider plugin:
git clone https://github.com/dmacvicar/terraform-provider-libvirt $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
make install
cd -

# Create plugin directory and copy the binary
mkdir -p $PLUGIN_PATH/registry.terraform.io/dmacvicar/libvirt/1.0.0/$PLATFORM/
cp $GOPATH/bin/terraform-provider-libvirt $PLUGIN_PATH/registry.terraform.io/dmacvicar/libvirt/1.0.0/$PLATFORM/terraform-provider-libvirt
```

Upon successful completion. Please follow the instructions outlined here
https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/docs/quickstart.md#start-install



## On IBM Power Systems

**Terraform** binary on IBM Power is not available for download. You will need to install it from source by running:

```
TAG_VERSION=v0.13.2
git clone https://github.com/hashicorp/terraform --branch $TAG $GOPATH/src/github.com/hashicorp/terraform
cd $GOPATH/src/github.com/hashicorp/terraform
TF_DEV=1 scripts/build.sh
```

Validate using:
```
$GOPATH/bin/terraform version
```


Identify your platform. All example commands assume Linux as a platform:

> Linux: linux_ppc64le

Identify your Terraform plugin directory. You will need to create the directory on your client machine:

> Linux: ~/.local/share/terraform/plugins OR /usr/local/share/terraform/plugins OR /usr/share/terraform/plugins.

Make sure to change `PLATFORM` and `PLUGIN_PATH` values based on your client machine.

**terraform-provider-libvirt**: Please refer to the section below for instructions on installing the libvirt provider plugin. For [more information](https://github.com/dmacvicar/terraform-provider-libvirt#building-from-source).

```
PLATFORM=linux_ppc64le
PLUGIN_PATH=~/.local/share/terraform/plugins

#Install the Libvirt provider plugin:
git clone https://github.com/dmacvicar/terraform-provider-libvirt $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
cd $GOPATH/src/github.com/dmacvicar/terraform-provider-libvirt
make install
cd -

# Create plugin directory and copy the binary
mkdir -p $PLUGIN_PATH/registry.terraform.io/dmacvicar/libvirt/1.0.0/$PLATFORM/
cp $GOPATH/bin/terraform-provider-libvirt $PLUGIN_PATH/registry.terraform.io/dmacvicar/libvirt/1.0.0/$PLATFORM/terraform-provider-libvirt
```


**terraform-provider-random**: Please refer to the section below for instructions on installing the random provider plugin. For [more information](https://github.com/hashicorp/terraform-provider-random#building-the-provider).

Note: Set `VERSION` to a compatible version eg. 2.3.0

```
VERSION=2.3.0
PLATFORM=linux_ppc64le
PLUGIN_PATH=~/.local/share/terraform/plugins

#Install the random provider plugin:
git clone https://github.com/hashicorp/terraform-provider-random --branch v$VERSION  $GOPATH/src/github.com/hashicorp/terraform-provider-random
cd $GOPATH/src/github.com/hashicorp/terraform-provider-random
make build
cd -

# Create plugin directory and copy the binary
mkdir -p $PLUGIN_PATH/registry.terraform.io/hashicorp/random/$VERSION/$PLATFORM/
cp $GOPATH/bin/terraform-provider-random $PLUGIN_PATH/registry.terraform.io/hashicorp/random/$VERSION/$PLATFORM/terraform-provider-random
```


**terraform-provider-ignition**: Please refer to the section below for instructions on installing the ignition provider plugin. For [more information](https://github.com/community-terraform-providers/terraform-provider-ignition#building-the-provider).

Note: Set `VERSION` to a compatible version eg. 2.1.0

```
VERSION=2.1.0
PLATFORM=linux_ppc64le
PLUGIN_PATH=~/.local/share/terraform/plugins

#Install the ignition provider plugin:
git clone https://github.com/community-terraform-providers/terraform-provider-ignition --branch v$VERSION  $GOPATH/src/github.com/terraform-providers/terraform-provider-ignition
cd $GOPATH/src/github.com/terraform-providers/terraform-provider-ignition
make build
cd -

# Create plugin directory and copy the binary
mkdir -p $PLUGIN_PATH/registry.terraform.io/terraform-providers/ignition/$VERSION/$PLATFORM/
cp $GOPATH/bin/terraform-provider-ignition $PLUGIN_PATH/registry.terraform.io/terraform-providers/ignition/$VERSION/$PLATFORM/terraform-provider-ignition
```


**terraform-provider-null**: Please refer to the section below for instructions on installing the null provider plugin. For [more information](https://github.com/hashicorp/terraform-provider-null#building-the-provider).

Note: Set `VERSION` to a compatible version eg. 2.1.2

```
VERSION=2.1.2
PLATFORM=linux_ppc64le
PLUGIN_PATH=~/.local/share/terraform/plugins

#Install the null provider plugin:
git clone https://github.com/hashicorp/terraform-provider-null --branch v$VERSION  $GOPATH/src/github.com/hashicorp/terraform-provider-null
cd $GOPATH/src/github.com/hashicorp/terraform-provider-null
make build
cd -

# Create plugin directory and copy the binary
mkdir -p $PLUGIN_PATH/registry.terraform.io/hashicorp/null/$VERSION/$PLATFORM/
cp $GOPATH/bin/terraform-provider-null $PLUGIN_PATH/registry.terraform.io/hashicorp/null/$VERSION/$PLATFORM/terraform-provider-null
```


Upon successful completion. Please follow the instructions outlined here
https://github.com/ocp-power-automation/ocp4-upi-kvm/blob/master/docs/quickstart.md#start-install


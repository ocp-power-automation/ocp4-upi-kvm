### Configure the Libvirt Host values
libvirt_uri     = "qemu+tcp://localhost/system"
host_address    = ""
images_path     = "/home/libvirt/openshift-images"

### Configure the Nodes details
bastion_image   = "http://remote_server/rhel-8.1-ppc64le-kvm.qcow2"
rhcos_image     = "http://remote_server/rhcos-4.3.18-ppc64le-qemu.ppc64le.qcow2"
bastion         = { memory = 4096, vcpu = 2 }
bootstrap       = { memory = 8192, vcpu = 4, count = 1 }
master          = { memory = 8192, vcpu = 4, count = 3 }
worker          = { memory = 8192, vcpu = 4, count = 2 }
network_cidr    = "192.168.88.0/24"
rhel_username   = "root"
rhel_password   = "123456"
public_key_file             = "~/.ssh/id_rsa.pub"
private_key_file            = "~/.ssh/id_rsa"
private_key                 = ""
public_key                  = ""
rhel_subscription_username  = ""
rhel_subscription_password  = ""

### OpenShift variables
openshift_install_tarball   = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/4.3.18/openshift-install-linux.tar.gz"
openshift_client_tarball    = "https://mirror.openshift.com/pub/openshift-v4/ppc64le/clients/ocp/4.3.18/openshift-client-linux.tar.gz"

#release_image_override     = ""

pull_secret_file            = "data/pull-secret.txt"
cluster_domain              = "example.com"
cluster_id_prefix           = "test"

dns_forwarders              = "8.8.8.8; 8.8.4.4"
installer_log_level         = "info"
ansible_extra_options       = "-v"

## Currently master branch has support for ppc64le; We will use current(May 15, 2020) commit# which is stable.
#helpernode_tag             = "fddbbc651153ef2966e5cb4d4167990b31c01ceb"

storage_type                = "nfs"
volume_size                 = "300" # Value in GB

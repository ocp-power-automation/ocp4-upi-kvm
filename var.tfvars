### Configure the Libvirt Host values
libvirt_uri     = "qemu+tcp://localhost/system"
host_address    = ""
images_path     = "/home/libvirt/openshift-images"

### Configure the Nodes details
bastion_image   = "http://remote_server/rhel-8.1-ppc64le-kvm.qcow2"
rhcos_image     = "http://remote_server/rhcos-4.4.9-ppc64le-qemu.ppc64le.qcow2"
bastion         = { memory = 8192, vcpu = 2 }
bootstrap       = { memory = 8192, vcpu = 4, count = 1 }
master          = { memory = 16384, vcpu = 4, count = 3 }
worker          = { memory = 16384, vcpu = 4, count = 2 }
cpu_mode        = ""
network_cidr    = "192.168.88.0/24"
rhel_username   = "root"
rhel_password   = "123456"
public_key_file             = "~/.ssh/id_rsa.pub"
private_key_file            = "~/.ssh/id_rsa"
private_key                 = ""
public_key                  = ""
rhel_subscription_username      = ""
rhel_subscription_password      = ""
rhel_subscription_org           = ""
rhel_subscription_activationkey = ""

### OpenShift variables
# openshift_install_tarball   = ""
# openshift_client_tarball    = ""

#release_image_override     = ""

pull_secret_file            = "data/pull-secret.txt"
cluster_domain              = "example.com"
cluster_id_prefix           = "test"
cluster_id                  = ""

dns_forwarders              = "1.1.1.1; 9.9.9.9"
chrony_config               = true
chrony_config_servers       = []
installer_log_level         = "info"
ansible_extra_options       = "-v"

#helpernode_tag             = ""
#install_playbook_tag       = ""

storage_type                = "nfs"
volume_size                 = "300" # Value in GB

#upgrade_version = ""
#upgrade_channel = ""  #(stable-4.x, fast-4.x, candidate-4.x) eg. stable-4.5
#upgrade_pause_time = "90"
#upgrade_delay_time = "600"

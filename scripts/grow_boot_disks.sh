#!/bin/bash

# Increase the size of /sysroot of each worker node

set -ex

source scripts/parameters.sh

function change_vmstate () {
	vm="$1"
	action="$2"

	delay="10"

	if [ "$action" == "shutdown" ]; then
		expected_state="shut"		# shut off, but with awk $3 just shut
	else
		expected_state="running"
	fi

	virsh $action $vm
	
	set +x

	for ((cnt=0; cnt<6; cnt++))
	do
		set -x
		state=$(virsh list --all | grep "$vm" | tail -n +1 | awk '{print $3}')
		if [ "$state" != "$expected_state" ]; then
			sleep $delay
		else
			cnt=6
		fi
		set +x
	done

	set -x
}

pushd $IMAGES_PATH/test-ocp$OCP_VERSION/

for (( i=0; i<$WORKERS; i++ ))
do
	vm=$(virsh list | grep worker-$i | awk '{print $2}')

	ip=$(oc get nodes -o wide | grep worker-$i | tail -n 1 | awk '{print $6}')

	change_vmstate $vm shutdown

	if [ ! -e "$IMAGES_PATH/test-ocp$OCP_VERSION/$vm.orig" ]; then
		cp $IMAGES_PATH/test-ocp$OCP_VERSION/$vm $IMAGES_PATH/test-ocp$OCP_VERSION/$vm.orig
	fi

	qemu-img resize $IMAGES_PATH/test-ocp$OCP_VERSION/$vm ${BOOT_DISK_SIZE}G

	change_vmstate $vm start

	set +x

	success=false
	for ((cnt=0; cnt<6; cnt++))
	do
		sleep 20

		set -x
		set +e
		xfs_output=$(ssh -o StrictHostKeyChecking=no core@$ip sudo xfs_growfs /)
		set -e
		set +x

		if [[ "$xfs_output" =~ "meta-data=/dev/mapper/coreos-luks-root-nocrypt" ]]; then
			cnt=6
			success=true
		fi
	done

	set -x

	if [ "$success" != true ]; then
		echo "ERROR: boot disk resize failed for VM $vm at $ipi.  May need to reboot it with original qcow2"
		echo "RECOVERY: Reboot VM or reboot VM with original qcow2"
	fi
done

popd

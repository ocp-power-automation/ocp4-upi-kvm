#!/bin/bash

# Deactivate VMs

while :
do
	ACTIVEVM=$(virsh list | tail -n 2 | head -n 1 | awk '{ print $2 }')
	if [[ -z "$ACTIVEVM" ]] || [[ "$ACTIVEVM" = \-* ]]; then
		break;
	fi
	echo "virsh destroy $ACTIVEVM"
	virsh destroy $ACTIVEVM
done

# Delete storage volumes

declare -i nvols
while :
do
	POOL=$(virsh pool-list --all | tail -n 2 | head -n 1 | awk '{ print $1 }')
	if [[ -z "$POOL" ]] || [[ "$POOL" == "default" ]] || [[ "$POOL" == \-* ]]; then
		break;
	fi
	nvols=$(virsh vol-list $POOL | wc -l)-3
	while :
	do
		if (( nvols < 1 )); then
			break;
		fi
		VOL=$(virsh vol-list $POOL | tail -n 2 | head -n 1 | awk '{ print $1 }')

		echo "virsh vol-delete $VOL --pool $POOL"
		virsh vol-delete $VOL --pool $POOL

		nvols=nvols-1
	done
	echo "virsh pool-destroy $POOL"
	virsh pool-destroy $POOL

	echo "virsh pool-delete $POOL"
	virsh pool-delete $POOL

	echo "virsh pool-undefine $POOL"
	virsh pool-undefine $POOL
done



# Delete VM definitions

while :
do
	INACTIVEVM=$(virsh list --all | tail -n 2 | head -n 1 | awk '{ print $2 }')
	if [[ -z "$INACTIVEVM" ]] || [[ "$INACTIVEVM" = \-* ]]; then
		break;
	fi
	echo "virsh undefine $INACTIVEVM"
	virsh undefine $INACTIVEVM
done



# Delete Virtual Networks

while :
do

	NET=$(virsh net-list --all | tail -n 2 | head -n 1 | awk '{ print $1 }')
	if [ "$NET" == "default" ]; then
		break;
	fi
	echo "virsh net-destroy $NET"
	virsh net-destroy $NET

	echo "virsh net-undefine $NET"
	virsh net-undefine $NET
done



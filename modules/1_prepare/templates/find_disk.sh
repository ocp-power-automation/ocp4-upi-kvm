storage_device=""
for device in $(ls -1 /dev/vd*|egrep -v "[0-9]$"); do
    if [[ ! -b $device"1" ]]; then
        # Convert disk size to GB
        device_size=$(lsblk -b -dn -o SIZE $device | awk '{print $1/1073741824}')
        if [[ -z $storage_device && $device_size == ${volume_size} ]]; then
            storage_device=$device
            break
        fi
    fi
done

echo $storage_device

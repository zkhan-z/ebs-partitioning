#!/bin/bash

partition_setup() {
    local disk="$1"
    local mount_point="$2"
    local uuid
    sudo gdisk "$disk" <<EOF
        o
        Y
        n
        1
        8300
        w
        Y
EOF
    sudo mkfs.ext4 "${disk}p1"
    if [ ! -d "$mount_point" ]; then
        sudo mkdir -p "$mount_point"
    fi
    sudo mount "${disk}p1" "$mount_point"
    uuid=$(sudo blkid -s UUID -o value "${disk}p1")
    echo "UUID=$uuid    $mount_point    ext4    defaults    0    0" | sudo tee -a /etc/fstab
}

partition_setup "/dev/nvme1n1" "/var"
partition_setup "/dev/nvme2n1" "/debug"

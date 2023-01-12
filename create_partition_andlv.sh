#!/bin/bash

# Check if the /var && /debug directory exists, if not create them
if [ ! -d "/var" ]; then
  sudo mkdir /var
fi

if [ ! -d "/debug" ]; then
  sudo mkdir /debug
fi

# create part and verify its created
sudo gdisk /dev/nvme1n1 <<EOF
o
Y
n
1



8300
w
Y
EOF

sudo gdisk -l /dev/nvme1n1 

sudo mkfs -t ext4 /dev/nvme1n1p1

sudo mount /dev/nvme1n1p1 /var

# Get the UUID of the first partition
UUID=$(blkid /dev/nvme1n1p1 | awk '{print $2}' | sed -e 's/"//g')

# Set the variables for UUID, mount point, file system, and options for /var
MOUNTPOINT=/var
FILESYSTEM=ext4
OPTIONS=defaults,nofail

# Add the entry to the fstab file
echo "$UUID          $MOUNTPOINT          $FILESYSTEM          $OPTIONS          0   0" | sudo tee -a /etc/fstab

# Create partition on second disk
sudo gdisk /dev/nvme2n1 <<EOF
o
Y
n
1



8300
w
Y
EOF

sudo gdisk -l /dev/nvme2n1

sudo mkfs -t ext4 /dev/nvme2n1p1

sudo mount /dev/nvme2n1p1 /debug

# Get the UUID of the first partition
UUID=$(blkid /dev/nvme2n1p1 | awk '{print $2}' | sed -e 's/"//g')

# Set the variables for UUID, mount point, file system, and options for /var
MOUNTPOINT=/debug
FILESYSTEM=ext4
OPTIONS=defaults,nofail

# Add the entry to the fstab file
echo "$UUID          $MOUNTPOINT          $FILESYSTEM          $OPTIONS          0   0" | sudo tee -a /etc/fstab

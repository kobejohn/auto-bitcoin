#! /bin/bash
set -e

PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

MOUNT_DIR="/mnt/disks/blockchain"


echo "Received shutdown / pre-emption signal. Shutting down gracefully."
su btcuser <<EOF
if bitcoin-cli -datadir="${MOUNT_DIR}" stop; then
    echo "Stopped bitcoind."
else
    echo "Failed to stop bitcoind."
fi
EOF

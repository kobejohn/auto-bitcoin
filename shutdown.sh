#!/bin/bash
set -e


MOUNT_DIR="/mnt/disks/blockchain"


echo "Received shutdown / pre-emption signal. Shutting down gracefully."
if bitcoin-cli -datadir="${MOUNT_DIR}" stop; then
    echo "Stopped bitcoind."
else
    echo "Failed to stop bitcoind."
fi

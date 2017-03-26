#!/bin/bash
set -e
echo "Received shutdown / pre-emption signal. Shutting down gracefully."
if bitcoin-cli -datadir=/mnt/disks/blockchain stop; then
    echo "Stopped bitcoind."
else
    echo "Failed to stop bitcoind."
fi

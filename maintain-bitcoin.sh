#! /bin/bash
set -e


MOUNT_DIR="/mnt/disks/blockchain"


# bitcoin client
bitcoind \
    -daemon \
    -datadir="${MOUNT_DIR}" \
    -dbcache=1000 \
    -prune=180000 \
    -disablewallet


# blockchain health
# todo: ...

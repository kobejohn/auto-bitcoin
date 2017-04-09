#! /bin/bash
set -e

PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

MOUNT_DIR="/mnt/disks/blockchain"


echo "*****************************************\nRun bitcoind daemon"
bitcoind \
    -daemon \
    -datadir="${MOUNT_DIR}" \
    -dbcache=1000 \
    -prune=180000 \
    -disablewallet


# blockchain health
# todo: ...

#! /bin/bash
set -e


# blockchain permanent storage
DISK_NAME="blockchain"
INSTANCE="bitcoin-worker"
ZONE="asia-northeast1-a"
DISK_DIR="/dev/disk/by-id/google-${DISK_NAME}"
MOUNT_DIR="/mnt/disks/blockchain"
# create disk or ignore
if gcloud compute disks create ${DISK_NAME} --size "200" --zone ${ZONE} --type "pd-standard" > /dev/null 2>&1; then
    echo "Created new disk for blockchain."
else echo "Unable to create blockchain disk. Assuming it has already been created."; fi

# Attach
if gcloud compute instances attach-disk ${INSTANCE} --disk ${DISK_NAME} --device-name ${DISK_NAME} --zone ${ZONE} --mode rw > /dev/null 2>&1; then
    echo "Attached blockchain disk to instance."
else echo "Unable to attach blockchain disk. Assuming it has already been attached."; fi

# Make blockchain disk persistent
if gcloud compute instances set-disk-auto-delete ${INSTANCE} --no-auto-delete --disk ${DISK_NAME} --zone ${ZONE} > /dev/null 2>&1; then
    echo "Set blockchain disk to persist regardless of instance status."
else echo "Unable to set no-auto-delete status of blockchain disk. Assuming it has already been set."; fi

# Format blockchain disk
if ! file -sL ${DISK_DIR} | grep ext4 > /dev/null 2>&1; then
    echo "Formatting new blockchain disk."
    mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard ${DISK_DIR}
else echo "Blockchain disk already formatted."; fi

# Mount blockchain disk
mkdir -p ${MOUNT_DIR} > /dev/null 2>&1 || true
if mount -o discard,defaults ${DISK_DIR} ${MOUNT_DIR} > /dev/null 2>&1; then
    echo "Mount blockchain disk to instance."
else echo "Unable to mount blockchain disk. Assuming already connected."; fi








chmod a+w ${MOUNT_DIR}


# bitcoin client
add-apt-repository ppa:bitcoin-unlimited/bu-ppa --yes && apt-get update --yes && apt-get install software-properties-common --yes && apt-get install bitcoind --yes


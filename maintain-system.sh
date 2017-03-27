#! /bin/bash
set -e


ZONE="asia-northeast1-a"
INSTANCE=$(gcloud compute instance-groups managed list-instances bitcoin-group --zone asia-northeast1-a | tail -n 1 | awk '{print $1;}')
DISK_NAME="blockchain"
DEVICE_DIR="/dev/disk/by-id/google-${DISK_NAME}"
MOUNT_DIR="/mnt/disks/blockchain"


# get or update the repo
AUTOBITCOIN_DIR=/auto-bitcoin
pushd "${AUTOBITCOIN_DIR}" && git pull && popd


# bitcoin non-root user
BTC_USER=btc_user
REFRESH_MINUTES=15
if ! id ${BTC_USER} > /dev/null 2>&1; then
    adduser --disabled-password --gecos "" ${BTC_USER}
fi


# blockchain permanent storage
echo "Confirm or create blockchain disk:"
if gcloud compute disks create ${DISK_NAME} --size "200" --type "pd-standard" --zone ${ZONE}; then
    echo "Created blockchain disk."
else
    echo "Unable to create blockchain disk. Assuming it has already been created."
fi


echo "Confirm or attach blockchain disk to instance:"
if gcloud compute instances attach-disk ${INSTANCE} --disk ${DISK_NAME} --device-name ${DISK_NAME} --mode rw --zone ${ZONE}; then
    # setting no-auto-delete seems to be idemopotent-friendly (no error if already set) so just run it
    gcloud compute instances set-disk-auto-delete ${INSTANCE} --no-auto-delete --disk ${DISK_NAME} --zone ${ZONE}
    echo "Attached blockchain disk to instance."
else
    echo "Unable to attach blockchain disk. Assuming it has already been attached."
fi


echo "Confirm or format blockchain disk:"
if ! (file -sL ${DEVICE_DIR} | grep ext4); then
    mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard ${DEVICE_DIR}
    echo "Formatted blockchain disk."
else
    echo "Blockchain disk is already formatted."
fi


echo "Confirm or create blockchain mount directory:"
if [ ! -d ${MOUNT_DIR} ]; then
    mkdir -p ${MOUNT_DIR}
    echo "Created blockchain mount directory."
else
    echo "Blockchain mount directory already exists."
fi


echo "Confirm or mount blockchain device:"
if ! mountpoint -q ${MOUNT_DIR}; then
    mount -o discard,defaults ${DEVICE_DIR} ${MOUNT_DIR}
    echo "Mounted blockchain device."
else
    echo "Unable to mount blockchain device. Assuming already mounted."
fi


# bitcoin client
echo "Confirm latest bitcoin client:"
add-apt-repository ppa:bitcoin-unlimited/bu-ppa --yes && apt-get update --yes && apt-get install software-properties-common --yes && apt-get install bitcoind --yes
echo "Confirmed latest bitcoin client."

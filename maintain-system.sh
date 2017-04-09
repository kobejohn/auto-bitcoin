#! /bin/bash
set -e

PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

AUTOBITCOIN_DIR=/auto-bitcoin
BTC_USER=btc_user

PROJECT="bu-test-160812"
ZONE="asia-northeast1-a"
INSTANCE_GROUP="bitcoin-instance-group"
INSTANCE=$(gcloud compute --project ${PROJECT} instance-groups managed list-instances ${INSTANCE_GROUP} --zone ${ZONE} | tail -n 1 | awk '{print $1;}')
DISK_NAME="blockchain"
DISK_SIZE_GB="200"
DEVICE_DIR="/dev/disk/by-id/google-${DISK_NAME}"
MOUNT_DIR="/mnt/disks/blockchain"


echo "*****************************************\nUpdate to latest auto-bitcoin:"
pushd "${AUTOBITCOIN_DIR}" && git pull && popd


echo "*****************************************\nConfirm or create bitcoin user:"
if ! id ${BTC_USER} > /dev/null 2>&1; then
    adduser --disabled-password --gecos "" ${BTC_USER}
fi


echo "*****************************************\nConfirm or create blockchain disk:"
if gcloud compute --project ${PROJECT} disks create ${DISK_NAME} --size "${DISK_SIZE_GB}" --type "pd-standard" --zone ${ZONE}; then
    echo "Created blockchain disk."
else
    echo "Unable to create blockchain disk. Assuming it has already been created."
fi


echo "*****************************************\nConfirm or attach blockchain disk to instance:"
if gcloud compute --project ${PROJECT} instances attach-disk ${INSTANCE} --disk ${DISK_NAME} --device-name ${DISK_NAME} --mode rw --zone ${ZONE}; then
    # setting no-auto-delete seems to be idemopotent-friendly (no error if already set) so just run it
    gcloud compute --project ${PROJECT} instances set-disk-auto-delete ${INSTANCE} --no-auto-delete --disk ${DISK_NAME} --zone ${ZONE}
    echo "Attached blockchain disk to instance."
else
    echo "Unable to attach blockchain disk. Assuming it has already been attached."
fi


echo "*****************************************\nConfirm or format blockchain disk:"
if ! (file -sL ${DEVICE_DIR} | grep ext4); then
    mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard ${DEVICE_DIR}
    echo "Formatted blockchain disk."
else
    echo "Blockchain disk is already formatted."
fi


echo "*****************************************\nConfirm or create blockchain mount directory:"
if [ ! -d ${MOUNT_DIR} ]; then
    mkdir -p ${MOUNT_DIR}
    echo "Created blockchain mount directory."
else
    echo "Blockchain mount directory already exists."
fi


echo "*****************************************\nConfirm or mount blockchain device:"
if ! mountpoint -q ${MOUNT_DIR}; then
    mount -o discard,defaults ${DEVICE_DIR} ${MOUNT_DIR}
    echo "Mounted blockchain device."
else
    echo "Unable to mount blockchain device. Assuming already mounted."
fi


echo "*****************************************\nConfirm latest bitcoin client:"
add-apt-repository ppa:bitcoin-unlimited/bu-ppa --yes && apt-get update --yes && apt-get install software-properties-common --yes && apt-get install bitcoind --yes && apt-get dist-upgrade --yes
echo "Confirmed latest bitcoin client."

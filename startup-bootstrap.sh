#! /bin/bash
set -e

PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

AUTOBITCOIN_REPO=git://github.com/kobejohn/auto-bitcoin.git
AUTOBITCOIN_DIR="/auto-bitcoin"


# base repository
if pushd "${AUTOBITCOIN_DIR}"; then
    git pull && popd
else
    git clone ${AUTOBITCOIN_REPO} "${AUTOBITCOIN_DIR}"
fi
chmod +x ${AUTOBITCOIN_DIR}/*.sh


# maintenance cron jobs
cp ${AUTOBITCOIN_DIR}/cron* /etc/cron.d/
chmod 644 /etc/cron.d/cron-maintain*  # only root has write access. no group. no executable

#! /bin/bash
set -e


AUTOBITCOIN_REPO=git://github.com/kobejohn/auto-bitcoin.git
AUTOBITCOIN_DIR="/auto-bitcoin"
BTC_USER=btc_user


# base repository
if pushd "${AUTOBITCOIN_DIR}"; then
    git pull && popd
else
    git clone ${AUTOBITCOIN_REPO} "${AUTOBITCOIN_DIR}"
fi
chmod +x ${AUTOBITCOIN_DIR}/maintain-system.sh
chmod +x ${AUTOBITCOIN_DIR}/maintain-bitcoin.sh
chmod +x ${AUTOBITCOIN_DIR}/startup-bootstrap.sh
chmod +x ${AUTOBITCOIN_DIR}/shutdown.sh


# maintain system as root every 30 minutes
echo "0,30 * * * * root ${AUTOBITCOIN_DIR}/maintain-system.sh >> /tmp/btc_maintain-system.log 2>&1" > /etc/cron.d/maintain-system
chmod +x /etc/cron.d/maintain-system


# maintain bitcoin as non-root every 30 minutes, "after" system maintenance
echo "5, 35 * * * * ${BTC_USER} ${AUTOBITCOIN_DIR}/maintain-bitcoin.sh >> /tmp/btc_maintain-bitcoin.log 2>&1" > /etc/cron.d/maintain-bitcoin
chmod +x /etc/cron.d/maintain-bitcoin

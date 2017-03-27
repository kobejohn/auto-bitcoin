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


# maintain system as root every hour
echo "0 * * * * root bash \"${AUTOBITCOIN_DIR}/maintain-system.sh\"" > /etc/cron.d/maintain-system


# maintain bitcoin as non-root every 15 minutes
echo "*/15 * * * * ${BTC_USER} bash \"${AUTOBITCOIN_DIR}/maintain-bitcoin.sh\"" > /etc/cron.d/maintain-bitcoin

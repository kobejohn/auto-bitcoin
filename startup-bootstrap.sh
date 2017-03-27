#! /bin/bash
set -e


AUTOBITCOIN_DIR=/auto-bitcoin
BTC_USER=btc_user
REFRESH_MINUTES=15


# base repository
if pushd "${AUTOBITCOIN_DIR}"; then
    git pull && popd
else
    git clone git://github.com/kobejohn/auto-bitcoin.git "${AUTOBITCOIN_DIR}"
fi


# maintain system as root
echo "0 * * * * root bash \"${AUTOBITCOIN_DIR}/maintain-system.sh\"" > /etc/cron.d/maintain-system


# maintain bitcoin as non-root
echo "*/${REFRESH_MINUTES} * * * * ${BTC_USER} bash \"${AUTOBITCOIN_DIR}/maintain-bitcoin.sh\"" > /etc/cron.d/maintain-bitcoin

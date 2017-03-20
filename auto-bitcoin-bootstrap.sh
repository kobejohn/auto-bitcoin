#! /bin/bash
set -e


# get or update the repo
AUTOBITCOIN_DIR=/auto-bitcoin
apt-get update --assume-yes && apt-get upgrade --assume-yes && apt-get install git --assume-yes
if pushd "${AUTOBITCOIN_DIR}"; then
    git pull && popd
else
    git clone git://github.com/kobejohn/auto-bitcoin.git "${AUTOBITCOIN_DIR}"
fi


# maintain system as root
echo "0 * * * * root \"${AUTOBITCOIN_DIR}/maintain-system.sh\"" > /etc/cron.d/maintain-system


# maintain bitcoin as non-root
BTC_USER=btc_user
REFRESH_MINUTES=15
if ! id ${BTC_USER} > /dev/null 2>&1; then
    adduser --disabled-password --gecos "" ${BTC_USER}
fi
echo "*/${REFRESH_MINUTES} * * * * ${BTC_USER} \"${AUTOBITCOIN_DIR}/maintain-bitcoin.sh\"" > /etc/cron.d/maintain-bitcoin


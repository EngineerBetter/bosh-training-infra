#!/bin/bash

CF_SOCKS5_PORT=12345
BOSH_SOCKS5_PORT=12346
BASTION_KEY_FILE=bastion-key.pem
BASTION_KEY_LOCATION=$HOME/.ssh/$BASTION_KEY_FILE
BOSH_USER=vcap

mkdir -p $HOME/.ssh

if [ ! -f $BASTION_KEY_LOCATION ]
then
    mv ./$BASTION_KEY_FILE $BASTION_KEY_LOCATION
fi

eval "$(cat .env)"

pkill ssh
ssh -4 -D $CF_SOCKS5_PORT -fNC $BASTION_USER@$BASTION_HOST -i $BASTION_KEY_LOCATION >/dev/null 2>/dev/null &
sleep 2
ssh -4 -D $BOSH_SOCKS5_PORT -fNC -i $BASTION_KEY_LOCATION -o ProxyCommand="nc -X 5 -x 127.0.0.1:${CF_SOCKS5_PORT} %h %p" vcap@$BOSH_ENVIRONMENT >/dev/null 2>/dev/null &
#!/bin/bash

CF_SOCKS5_PORT="12345"
BOSH_SOCKS5_PORT="12346"
BASTION_KEY_FILE=bastion-key.pem
BASTION_KEY_LOCATION=$HOME/.ssh/$BASTION_KEY_FILE
BOSH_USER=vcap
export NO_PROXY=github.com
export no_proxy=github.com

mkdir -p $HOME/.ssh

if [ ! -f $BASTION_KEY_LOCATION ]
then
    mv ./$BASTION_KEY_FILE $BASTION_KEY_LOCATION
fi

eval "$(cat .env)"

if  [[ $(ps -ef | grep -c "[s]sh -4 -D $CF_SOCKS5_PORT") -eq 0 ]]
then
    ssh -4 -D $CF_SOCKS5_PORT -fNC -o StrictHostKeyChecking="no" $BASTION_USER@$BASTION_HOST -i $BASTION_KEY_LOCATION >/dev/null 2>/dev/null &
fi

sleep 2
if [[ $(ps -ef | grep -c "[s]sh -4 -D $CF_SOCKS5_PORT") -eq 1 ]] && [[ $(ps -ef | grep -c "[s]sh -4 -D $BOSH_SOCKS5_PORT") -eq 0 ]]
then
	ssh -4 -D $BOSH_SOCKS5_PORT -fNC -i $BASTION_KEY_LOCATION -o StrictHostKeyChecking="no" -o ProxyCommand="nc -X 5 -x 127.0.0.1:${CF_SOCKS5_PORT} %h %p" vcap@$BOSH_ENVIRONMENT >/dev/null 2>/dev/null &
fi

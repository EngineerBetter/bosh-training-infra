#!/bin/bash

BASTION_KEY_FILE=bastion-key.pem
BASTION_KEY_LOCATION=$HOME/.ssh/$BASTION_KEY_FILE

mkdir -p $HOME/.ssh

if [ ! -f $BASTION_KEY_LOCATION ]
then
    mv ./$BASTION_KEY_FILE $BASTION_KEY_LOCATION
fi

eval "$(cat .env)"

if [ ! $(pgrep ssh) ]
then
    ssh -4 -D 12345 -fNC $BASTION_USER@$BASTION_HOST -i $BASTION_KEY_LOCATION &
fi
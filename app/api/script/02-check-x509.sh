#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../../../"; pwd)
export APP_PATH=$PARENT_PATH/app/api
export WALLET_PATH=$APP_PATH/bin/wallet

for mspIndex in {1..2}  # OrgMSP
do
    for userIndex in {1..5} # User
    do
        export WALLET_USERNAME=User$userIndex
        export WALLET_DOMAIN=org$mspIndex-example.com

        echo "============================================="
        echo "==== $WALLET_USERNAME@$WALLET_DOMAIN.pem ===="
        openssl x509 -text -noout -in $WALLET_PATH/$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN.pem
        openssl x509 -checkend 86400 -noout -in $WALLET_PATH/$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN.pem
        echo "============================================="
    done
done
exit 0
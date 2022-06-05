#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../../../"; pwd)
export APP_PATH=$PARENT_PATH/app/api
export WALLET_PATH=$APP_PATH/bin/wallet
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos

# create wallet directory
rm -f -r $WALLET_PATH/* && mkdir -p $WALLET_PATH

for mspIndex in {1..2}  # OrgMSP
do
    for userIndex in {1..5} # User
    do
        export WALLET_USERNAME=User$userIndex
        export WALLET_DOMAIN=org$mspIndex-example.com
        export WALLET_MSPID=Org$mspIndex
        export WALLET_MSPID+=MSP
        export IDENTITY_DIR=$CRYPTO_PATH/bin/peerOrganizations/$WALLET_DOMAIN/users/$WALLET_USERNAME@$WALLET_DOMAIN
        export IDENTITY_CERT=$IDENTITY_DIR/msp/signcerts/$WALLET_USERNAME@$WALLET_DOMAIN-cert.pem
        export IDENTITY_PRIV=$IDENTITY_DIR/msp/keystore/priv_sk
        mkdir -p $WALLET_PATH/$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN
        
        node ./src/addToWallet.js

        export WALLET_CERTIFICATE=$(jq '.credentials.certificate' $WALLET_PATH/$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN.id)
        export WALLET_CERTIFICATE="${WALLET_CERTIFICATE:1:-1}"
        export WALLET_CERTIFICATE=$(echo $WALLET_CERTIFICATE | sed 's/\\n/\n/g')
        echo "$WALLET_CERTIFICATE" > $WALLET_PATH/$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN/$WALLET_USERNAME@$WALLET_DOMAIN.pem
    done
done
exit 0
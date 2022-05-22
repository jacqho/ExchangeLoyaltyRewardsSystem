#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos
export LDAP_PATH=$NETWORK_PATH/identity-services/ldap

# Network Down
docker-compose -f $NETWORK_PATH/docker-compose-ca.yaml down

# Remove resources
rm -f -r $LDAP_PATH/bin/*
rm -f -r $FABRIC_CA_PATH/bin/*
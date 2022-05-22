#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos
export CRYPTO_ORG1_PATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com
export CRYPTO_ORG2_PATH=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com
export LDAP_PATH=$NETWORK_PATH/identity-services/ldap
export FABRIC_CA_PATH=$NETWORK_PATH/identity-services/fabric-ca
export FABRIC_CA_ORG1_PATH=$FABRIC_CA_PATH/bin/org1
export FABRIC_CA_ORG2_PATH=$FABRIC_CA_PATH/bin/org2

# Remove resources
rm -f -r $LDAP_PATH/bin/*
rm -f -r $FABRIC_CA_PATH/bin/*

# Copy certificates
mkdir -p $FABRIC_CA_ORG1_PATH/certificates && cp $CRYPTO_ORG1_PATH/ca/ca.org1-example.com-cert.pem $FABRIC_CA_ORG1_PATH/certificates/ca-cert.pem && cp $CRYPTO_ORG1_PATH/ca/priv_sk $FABRIC_CA_ORG1_PATH/certificates/priv_sk
mkdir -p $FABRIC_CA_ORG2_PATH/certificates && cp $CRYPTO_ORG1_PATH/ca/ca.org1-example.com-cert.pem $FABRIC_CA_ORG2_PATH/certificates/ca-cert.pem && cp $CRYPTO_ORG1_PATH/ca/priv_sk $FABRIC_CA_ORG2_PATH/certificates/priv_sk

# Network Up
docker-compose -f $NETWORK_PATH/docker-compose-ca.yaml up -d
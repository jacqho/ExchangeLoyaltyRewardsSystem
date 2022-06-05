#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../../../"; pwd)
export APP_PATH=$PARENT_PATH/app/api
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos
export ORDER_TLSCA=$CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export Org1_PEER1_TLSCA=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export Org2_PEER1_TLSCA=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt

# copy configuation to bin
rm -f -r $APP_PATH/bin/connection.json
cp -n $APP_PATH/config/connection.json $APP_PATH/bin/temp-connection.json

sleep 1
echo $(cat $APP_PATH/bin/temp-connection.json | jq --arg ORDER_TLSCA "$ORDER_TLSCA" '.orderers["orderer.example.com"].tlsCACerts.path = $ORDER_TLSCA') > $APP_PATH/bin/temp-connection.json
echo $(cat $APP_PATH/bin/temp-connection.json | jq --arg Org1_PEER1_TLSCA "$Org1_PEER1_TLSCA" '.peers["peer0.org1-example.com"].tlsCACerts.path = $Org1_PEER1_TLSCA') > $APP_PATH/bin/temp-connection.json
echo $(cat $APP_PATH/bin/temp-connection.json | jq --arg Org2_PEER1_TLSCA "$Org2_PEER1_TLSCA" '.peers["peer0.org2-example.com"].tlsCACerts.path = $Org2_PEER1_TLSCA') > $APP_PATH/bin/temp-connection.json

jq . $APP_PATH/bin/temp-connection.json > $APP_PATH/bin/connection.json
rm -f -r $APP_PATH/bin/temp-connection.json
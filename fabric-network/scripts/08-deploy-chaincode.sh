#!/bin/bash

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos
export FABRIC_NETWORK_PATH=$NETWORK_PATH/network
export CHAINCODE_PATH=$FABRIC_NETWORK_PATH/chaincode
export CONTRACT_PATH=$CHAINCODE_PATH/src/reward

# Setup hyperledger bin path
export PATH=$NETWORK_PATH/bin:$PATH

# Build chaincode package
cd $CONTRACT_PATH
rm -f -r ./vendor
rm go.*
rm reward

go mod init reward
go get github.com/hyperledger/fabric-contract-api-go/contractapi
go get github.com/pkg/errors
go mod vendor
go install
go build

# Set cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/core

rm -f -r $CHAINCODE_PATH/bin/reward.tar.gz
cd $CHAINCODE_PATH/bin

# Package the chaincode
peer lifecycle chaincode package reward.tar.gz --path $CONTRACT_PATH --lang golang --label reward

# Set environment to Org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Install the chaincode
peer lifecycle chaincode install reward.tar.gz

# Set environment to Org2
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/users/Admin@org2-example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

# Install the chaincode
peer lifecycle chaincode install reward.tar.gz

# export the ID as a variable
export CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled 2>&1 | awk -F "[, ]+" '/Label: reward/{print $3}')

# approve for Org2
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name reward --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Check the approvals
peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name reward --version 1.0 --sequence 1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json

# Set environment to Org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051

# Approve for Org1
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name reward --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Check the approvals
peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name reward --version 1.0 --sequence 1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --output json

# Commit the approved chaincode for both of the organizations
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name reward --version 1.0 --sequence 1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --peerAddresses localhost:7051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt

# Checkout all the chaincode defenitions on the channel
peer lifecycle chaincode querycommitted --channelID channel1 --name reward --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
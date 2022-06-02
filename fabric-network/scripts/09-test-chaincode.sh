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

# Set cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/core

# Set environment to Org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051

echo "Generate Reward to org1-user1, 1000"
# Generate Reward in Org1
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C channel1 -n reward --peerAddresses localhost:7051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt -c '{"Args":["GenerateReward","org1-user1", "1000"]}'
sleep 3

# View Reward in Org1
peer chaincode query -C channel1 -n reward -c '{"Args":["ViewReward","org1-user1"]}'

# Set environment to Org2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/users/Admin@org2-example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

echo "Generate Reward to org2-user1, 100"
# Generate Reward in Org2
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C channel1 -n reward --peerAddresses localhost:7051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt -c '{"Args":["GenerateReward","org2-user1", "100"]}'
sleep 3

# View Reward in Org2
peer chaincode query -C channel1 -n reward -c '{"Args":["ViewReward","org2-user1"]}'

# Set environment to Org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051

echo "Transfer Reward to org1-user1 -> org2-user1, 100; (org1-user1: 900), (org2-user1: 200)"
# Transfer Reward
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C channel1 -n reward --peerAddresses localhost:7051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles $CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt -c '{"Args":["TransferReward","org1-user1", "org2-user1", "100"]}'
sleep 3

echo "View Reward to org1-user1"
# View Reward in Org1
peer chaincode query -C channel1 -n reward -c '{"Args":["ViewReward","org1-user1"]}'

# Set environment to Org2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/users/Admin@org2-example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

echo "View Reward to org2-user1"
# View Reward in Org2
peer chaincode query -C channel1 -n reward -c '{"Args":["ViewReward","org2-user1"]}'

#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos
export FABRIC_NETWORK_PATH=$NETWORK_PATH/network
export CHANNEL_ARTIFACT_PATH=$FABRIC_NETWORK_PATH/bin/channel-artifacts

# Setup hyperledger bin path
export PATH=$NETWORK_PATH/bin:$PATH

# Create channel artifacts folder
rm -f -r $CHANNEL_ARTIFACT_PATH && mkdir -p $CHANNEL_ARTIFACT_PATH

# Set the cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/tx

# Create the channel creation transaction
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx $CHANNEL_ARTIFACT_PATH/channel1.tx -channelID channel1

# Set environment to the admin user of Org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Set the cfg path to the core file
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/core

# Create the channel
peer channel create -o localhost:7050  --ordererTLSHostnameOverride orderer.example.com -c channel1 -f $CHANNEL_ARTIFACT_PATH/channel1.tx --outputBlock $CHANNEL_ARTIFACT_PATH/channel1.block --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Join org1 to the channel
peer channel join -b $CHANNEL_ARTIFACT_PATH/channel1.block

# Show the blockheight of the channel
peer channel getinfo -c channel1

# Set environment to the admin user of Org2
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/peers/peer0.org2-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org2-example.com/users/Admin@org2-example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

# Fetch the first block from the ordering service
peer channel fetch 0 $CHANNEL_ARTIFACT_PATH/channel_org2.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c channel1 --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Join org2 to the channel
peer channel join -b $CHANNEL_ARTIFACT_PATH/channel_org2.block

# Set the cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/tx

# Create the anchor update transaction for org2
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate $CHANNEL_ARTIFACT_PATH/org2_anchor.tx -channelID channel1 -asOrg Org2MSP

# Set the cfg path to the core file
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/core

# Send the anchor update to the ordering service
peer channel update -o localhost:7050 -c channel1 -f $CHANNEL_ARTIFACT_PATH/org2_anchor.tx --ordererTLSHostnameOverride orderer.example.com --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Set environment to the admin user of Org1
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/peers/peer0.org1-example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_PATH/bin/peerOrganizations/org1-example.com/users/Admin@org1-example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Set the cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/tx

# Create the anchor update transaction for org1
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate $CHANNEL_ARTIFACT_PATH/org1_anchor.tx -channelID channel1 -asOrg Org1MSP

# Set the cfg path to the core file
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/core

# Send the anchor update to the ordering service
peer channel update -o localhost:7050 -c channel1 -f $CHANNEL_ARTIFACT_PATH/org1_anchor.tx  --ordererTLSHostnameOverride orderer.example.com --tls --cafile $CRYPTO_PATH/bin/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Show the blockheight of the channel
peer channel getinfo -c channel1



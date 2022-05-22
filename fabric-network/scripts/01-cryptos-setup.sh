#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export CRYPTO_PATH=$NETWORK_PATH/identity-services/cryptos

# Setup hyperledger bin path
export PATH=$NETWORK_PATH/bin:$PATH

# Remove all crypto materials
rm -f -r $CRYPTO_PATH/bin/*

# Generate crypto materials 
cryptogen generate --config=$CRYPTO_PATH/config/crypto/crypto-config-org1.yaml --output=$CRYPTO_PATH/bin/.
cryptogen generate --config=$CRYPTO_PATH/config/crypto/crypto-config-org2.yaml --output=$CRYPTO_PATH/bin/.
cryptogen generate --config=$CRYPTO_PATH/config/crypto/crypto-config-orderer.yaml --output=$CRYPTO_PATH/bin/.

# set the cfg path
export FABRIC_CFG_PATH=$CRYPTO_PATH/config/tx

# create genesis block
mkdir -p $CRYPTO_PATH/bin/genesis-block && configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock $CRYPTO_PATH/bin/genesis-block/genesis.block
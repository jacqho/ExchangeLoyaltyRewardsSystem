#!/bin/bash

# remove the old materials
sudo rm -fr ~/new/network/organizations/ordererOrganizations/*
sudo rm -fr ~/new/network/organizations/peerOrganizations/*
sudo rm -fr ~/new/network/system-genesis-block/*

pushd ~/new/network

# generate crypto materials
cryptogen generate --config=./organizations/cryptogen/crypto-config-org1.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-org2.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"

# set the cfg path
export FABRIC_CFG_PATH=$PWD/configtx/

# create the genesis block
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block 

popd
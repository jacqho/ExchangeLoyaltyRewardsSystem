#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export FABRIC_NETWORK_PATH=$NETWORK_PATH/network

# Remove resources
rm -f -r $FABRIC_NETWORK_PATH/bin/*

# Network Up
docker-compose -f $NETWORK_PATH/docker-compose-network.yaml up -d
#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)"; pwd)
export SCRIPT_PATH=$PARENT_PATH/scripts

cd $SCRIPT_PATH

# Network down
./06-fabric-network-down.sh
./03-ca-network-down.sh

# Network up
./01-cryptos-setup.sh
./02-ca-network-up.sh
./05-fabric-network-up.sh
./07-create-channel.sh
./08-deploy-chaincode.sh
./09-test-chaincode.sh

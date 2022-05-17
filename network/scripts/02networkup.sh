#!/bin/bash

pushd ~/new/network/docker

docker-compose -f ./docker-compose-test-net.yaml up -d 

popd
#!/bin/bash

pushd ~/new/network/docker

docker-compose -f ./docker-compose-test-net.yaml down
docker-compose -f ./docker-compose-ca.yaml down


docker volume prune -f

popd

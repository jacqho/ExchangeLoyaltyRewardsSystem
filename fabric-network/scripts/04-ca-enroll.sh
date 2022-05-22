#!/bin/bash

# Setup paths alias
export PARENT_PATH=$(builtin cd "$(pwd)/../.."; pwd)
export NETWORK_PATH=$PARENT_PATH/fabric-network
export FABRIC_CA_PATH=$NETWORK_PATH/identity-services/fabric-ca

# Remove all 

# Setup hyperledger bin path
export PATH=$NETWORK_PATH/bin:$PATH

# Client Enroll
fabric-ca-client enroll -u https://org1-admin:adminpw@localhost:7054 --tls.certfiles $FABRIC_CA_PATH/bin/org1/tls-cert.pem
fabric-ca-client enroll -u https://org1-user1:userpw@localhost:7054 --tls.certfiles $FABRIC_CA_PATH/bin/org1/tls-cert.pem
fabric-ca-client enroll -u https://org1-user2:userpw@localhost:7054 --tls.certfiles $FABRIC_CA_PATH/bin/org1/tls-cert.pem

fabric-ca-client enroll -u https://org2-admin:adminpw@localhost:7055 --tls.certfiles $FABRIC_CA_PATH/bin/org2/tls-cert.pem
fabric-ca-client enroll -u https://org2-user1:userpw@localhost:7055 --tls.certfiles $FABRIC_CA_PATH/bin/org2/tls-cert.pem
fabric-ca-client enroll -u https://org2-user2:userpw@localhost:7055 --tls.certfiles $FABRIC_CA_PATH/bin/org2/tls-cert.pem
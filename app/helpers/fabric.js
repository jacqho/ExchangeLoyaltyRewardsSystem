'use strict';
const { Wallets, Gateway } = require('fabric-network');
const path = require('path');
const fs = require('fs');

exports.connectFabric = async (mspId, domain) => {
    const ccpPath = path.join(__dirname, '../bin/connection.json');
    const connectionProfileJson = (await fs.promises.readFile(ccpPath)).toString();
    const connectionProfile = JSON.parse(connectionProfileJson);
    const walletPath = path.join(__dirname, '../bin/wallet/' + mspId + '/' + domain);
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const gateway = new Gateway();
    await gateway.connect(connectionProfile, { wallet, identity: domain, discovery: { enabled: true, asLocalhost: true }});
    const network = await gateway.getNetwork('channel1');
    return network.getContract('reward');
};
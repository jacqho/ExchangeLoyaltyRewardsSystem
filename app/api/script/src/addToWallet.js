'use strict';

const fs = require('fs');
const { Wallets } = require('fabric-network');

async function main() {
    const wallet = await Wallets.newFileSystemWallet(process.env.WALLET_PATH + '/' + 
        process.env.WALLET_DOMAIN + '/' + 
        process.env.WALLET_USERNAME + '@' + 
        process.env.WALLET_DOMAIN);
    try {
        const certificate = fs.readFileSync(process.env.IDENTITY_CERT).toString();
        const privateKey = fs.readFileSync(process.env.IDENTITY_PRIV).toString();
        const identityLabel = process.env.WALLET_USERNAME + '@' + process.env.WALLET_DOMAIN;

        const identity = {
            credentials: {
                certificate,
                privateKey
            },
            mspId: process.env.WALLET_MSPID,
            type: 'X.509'
        }

        await wallet.put(identityLabel, identity);

    } catch (error) {
        console.log(`Error adding to wallet. ${error}`);
        console.log(error.stack);
    }
}

main().then(() => {
    console.log('Complete create wallet: ' +  process.env.WALLET_USERNAME + '@' + process.env.WALLET_DOMAIN);
}).catch((e) => {
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
});

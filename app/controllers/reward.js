const fabric = require('../helpers/fabric');

exports.generate = async (req, res) => {
    try{
        const { mspId, domain, to, amount } = req.body;
        const contract = await fabric.connectFabric(mspId, domain);
        await contract.submitTransaction('GenerateReward', to, amount);
        const result = await contract.evaluateTransaction('ViewReward', to);
        res.status(201).json({
            "message": "Complete Generated",
            data: JSON.parse(result.toString())
        });
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}

exports.transfer = async (req, res) => {
    try{
        const { mspId, domain, from, to, amount } = req.body;
        const contract = await fabric.connectFabric(mspId, domain);
        await contract.submitTransaction('TransferReward', from, to, amount);
        const result = await contract.evaluateTransaction('ViewReward', from);
        const json = JSON.parse(result.toString());
        res.status(201).json({
            "message": "Complete Transfer",
            data: {
                "ID": json.ID,
                "Remain": json.point
            }
        });
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}

exports.view = async (req, res) => {
    try{
        const { mspId, domain, alias } = req.body;
        const contract = await fabric.connectFabric(mspId, domain);
        const result = await contract.evaluateTransaction('ViewReward', alias);
        res.status(200).json(JSON.parse(result.toString()));
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}
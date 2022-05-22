const database = require('../helpers/database');

exports.generate = async (req, res) => {
    try{
        res.status(201).json("generate");
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}

exports.transfer = async (req, res) => {
    try{
        res.status(201).json("transfer");
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}

exports.view = async (req, res) => {
    try{
        res.status(200).json("view");
    } catch(error){
        res.status(500).json({ message: error.message });
    }
}
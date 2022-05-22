const mongoose = require("mongoose");
const Profile = require("../models/profile");
const Homeowner = require('../models/profile');

exports.connectDB = async (connection_url) => {
    await mongoose.connect(connection_url, { useNewUrlParser: true, useUnifiedTopology: true })
        .catch((error) => {
            throw new Error(`Unable to connect DB. ${error}`);
        });
    return true;
};

exports.getById = async(id) => {
    try{
        return await Profile.findById(mongoose.Types.ObjectId(id));
    }
    catch(error){
        throw new Error(`Unable to get record, id: ${id}. ${error.message}`);
    }
}
const mongoose = require("mongoose");

const schema = mongoose.Schema({
    name: {
        type: String,
        require: true,
        maxLength: 255
    },
    keystore: {
        type: String,
        require: true
    }
});

let Profile = mongoose.model("Profile", schema);

module.exports = Profile;
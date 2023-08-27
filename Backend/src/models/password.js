const mongoose = require('mongoose');

const passwordschema = mongoose.Schema({
    mobileno: {
        type: String,
        unique: true,
        required: true,
    },

    password: {
        type: String,
        required: true,
    }
});

module.exports = mongoose.model("password", passwordschema);
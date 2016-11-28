var exec = require('cordova/exec');

module.exports = {
    init: function (codeName, secreteKey, environment, success, error) {
        exec(success, error, "Paymentez", "init", [codeName, secreteKey, environment]);
    },
    addCard: function (firstName, lastName, email, success, error) {
        exec(success, error, "Paymentez", "addCard", [email, firstName, lastName]);
    }
};



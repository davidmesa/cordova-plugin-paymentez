var exec = require('cordova/exec');

module.exports = {
    init: function (codeName, secreteKey, environment, success, error) {
        exec(success, error, "Paymentez", "init", [codeName, secreteKey, environment]);
    },
    addCard: function (uid, email, success, error) {
        exec(success, error, "Paymentez", "addCard", [email, uid]);
    },
    list: function (uid, sucess, error) {
        exec(sucess, error, "Paymentez", "listCards", [uid]);
    },
    debitCard: function (cardReference, productAmount, productDescription, devReference,
                         vat, email, uid, success, error) {
        exec(success, error, "Paymentez", "debitCard", [cardReference, productAmount, productDescription,
            devReference, vat, email, uid]);
    }
};
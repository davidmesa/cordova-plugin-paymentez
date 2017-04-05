import

public class PaymentezPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("init")) {
            String codeName = args.getString(0);
            String secreteKey = args.getString(1);
            String environment = args.getString(2);
            this.init(codeName, secreteKey, environment, callbackContext);
            return true;
        } else if (action.equals("addCard")) {
            String email = args.getString(0);
            String uid = args.getString(1);
            this.addCard(email, uid, callbackContext);
        } else if (action.equals("verifyByAmount")) {
            String transactionId = args.getString(0);
            String uid = args.getString(1);
            String amount = args.getString(2);
            this.verifyByAmount(transactionId, uid, amount, callbackContext);
        } else if (action.equals("listCards")) {
            String uid = args.getString(0);
            this.listCards(uid, callbackContext);
        }
        return false;
    }

    public void init(String codeName, String secreteKey, String environment, CallbackContext callbackContext) {
        callbackContext.success();
    }

    public void addCard(String email, String uid, CallbackContext callbackContext) {
        callbackContext.success();
    }

    public void verifyByAmount(String transactionId, String uid, String amount, CallbackContext callbackContext) {
        callbackContext.success();
    }

    public void listCards(String uid) {
        callbackContext.success();
    }

}
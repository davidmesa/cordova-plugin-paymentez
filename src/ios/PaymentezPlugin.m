//
//  PaymentezPlugin.m
//  NoBed
//
//  Created by David Mesa on 11/26/16.
//
//

#import "PaymentezPlugin.h"
#import <PaymentezSDK/PAymentezSDK-Swift.h>

@interface PaymentezPlugin()

  @property(nonatomic, strong, readwrite) CDVInvokedUrlCommand *command;

@end

@implementation PaymentezPlugin

- (void) init:(CDVInvokedUrlCommand *)command {
  self.command = command;

  NSString* codeName = [command argumentAtIndex:0];
  NSString* secreteKey = [command argumentAtIndex:1];
  NSString* environment = [command argumentAtIndex:2];


  [PaymentezSDKClient setEnvironment:codeName secretKey:secreteKey testMode:![environment isEqualToString:@"Production"]];
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}

- (void) addCard:(CDVInvokedUrlCommand *)command {

  self.command = command;

  NSString* email = [command argumentAtIndex:0];
  NSString* uid = [command argumentAtIndex:1];

  UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;

  [PaymentezSDKClient showAddViewControllerForUser:uid email:email presenter:top callback:^(PaymentezSDKError *error, BOOL closed, BOOL added) {
    CDVPluginResult *pluginResult;
    if(error != nil)
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
    else if (closed)
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"User closed the modal"];
    else if (added)
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

  }];
}

- (void) verifyByAmount: (CDVInvokedUrlCommand *)command {
  self.command = command;

  NSString* transactionId = [command argumentAtIndex:0];
  NSString* uid = [command argumentAtIndex:0];
  NSString* amount = [command argumentAtIndex:0];

  [PaymentezSDKClient verifyWithAmount:transactionId uid:uid amount:[amount doubleValue] callback:^
   (PaymentezSDKError * error, NSInteger attemptsRemaining, PaymentezTransaction * transaction) {
    CDVPluginResult *pluginResult;
     if(transaction != nil)
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
     else if (attemptsRemaining > 0)
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%li", (long)attemptsRemaining]];
     else if (error != nil)
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
     else
       pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error not identified"];

     [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

   }];

}

- (void) listCards: (CDVInvokedUrlCommand *)command {
  self.command = command;

  NSString* uid = [command argumentAtIndex:0];

  [PaymentezSDKClient listCards:uid callback:^(PaymentezSDKError * error, NSArray<PaymentezCard *> * list) {
    CDVPluginResult *pluginResult;
    if(error == nil){
      NSMutableArray *result = [[NSMutableArray alloc] init];
      for (int i = 0; i<list.count; i=i+1) {
        PaymentezCard *newCard = [list objectAtIndex:i];
        NSDictionary *card = [NSDictionary dictionaryWithObjectsAndKeys:
                              newCard.cardReference, @"cardReference",
                              newCard.type, @"type",
                              newCard.cardHolder, @"cardHolder",
                              newCard.termination, @"termination",
                              newCard.expiryMonth, @"expiryMonth",
                              newCard.expiryYear, @"expiryYear",
                              newCard.bin, @"bin",nil];
        [result addObject:card];
      }
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
    }
    else
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  } ];
}

- (void) debitCard: (CDVInvokedUrlCommand *)command {
  self.command = command;

  NSString* cardReference = [command argumentAtIndex:0];
  NSString* productAmount = [command argumentAtIndex:1];
  NSString* productDescription = [command argumentAtIndex:2];
  NSString* devReference = [command argumentAtIndex:3];
  NSString* vat = [command argumentAtIndex:4];
  NSString* email = [command argumentAtIndex:5];
  NSString* uid = [command argumentAtIndex:6];


  PaymentezDebitParameters *parameters = [[PaymentezDebitParameters alloc] init];
  parameters.cardReference = cardReference;
  parameters.productAmount = [productAmount doubleValue];
  parameters.productDescription = productDescription;
  parameters.devReference = devReference;
  parameters.vat = [vat doubleValue];
  parameters.email = email;
  parameters.uid = uid;

  [PaymentezSDKClient debitCard:parameters    callback:^(PaymentezSDKError *error, PaymentezTransaction *transaction) {
    CDVPluginResult *pluginResult;
    if ( error == nil)
    {
      NSDictionary *transResult = [NSDictionary dictionaryWithObjectsAndKeys:
                            transaction.transactionId, @"transactionId",
                            transaction.paymentDate, @"paymentDate",
                            transaction.carrierData, @"carrierData",nil];
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:transResult];
    }
    else
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];

}

@end
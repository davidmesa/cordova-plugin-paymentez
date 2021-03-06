//
//  PaymentezPlugin.h
//  NoBed
//
//  Created by David Mesa on 11/26/16.
//
//

#import <Cordova/CDV.h>

@interface PaymentezPlugin : CDVPlugin

- (void) init:(CDVInvokedUrlCommand *)command;

- (void) addCard:(CDVInvokedUrlCommand *)command;

- (void) verifyByAmount: (CDVInvokedUrlCommand *)command;

- (void) listCards: (CDVInvokedUrlCommand *)command;

- (void) debitCard: (CDVInvokedUrlCommand *)command;

@end

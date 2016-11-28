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

}

- (void) addCard:(CDVInvokedUrlCommand *)command {

  self.command = command;

  NSString* email = [command argumentAtIndex:0];
  NSString* firstName = [command argumentAtIndex:1];
  NSString* lastName = [command argumentAtIndex:2];

  UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;

  [PaymentezSDKClient showAddViewControllerForUser:[NSString stringWithFormat:@"%@ %@", firstName, lastName] email:email presenter:top callback:^(PaymentezSDKError *error, BOOL closed, BOOL added) {
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

@end
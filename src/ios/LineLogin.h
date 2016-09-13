#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "AppDelegate.h"

@interface LineLogin : CDVPlugin 
- (void)login:(CDVInvokedUrlCommand *)command;
- (void)logout:(CDVInvokedUrlCommand *)command;
@end

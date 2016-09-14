#import "LineLogin.h"
#import <LineAdapter/LineAdapter.h>
#import <LineAdapterUI/LineAdapterUI.h>

@interface LineLogin ()
@property (strong, nonatomic) NSString* loginCallbackId;
@end

@implementation LineLogin {
    LineAdapter *adapter;
}

- (void)pluginInitialize 
{
    NSLog(@"Starting Line Login plugin");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];
    adapter = [LineAdapter adapterWithConfigFile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorizationDidChange:) name:LineAdapterAuthorizationDidChangeNotification object:nil];

}

- (void) applicationDidFinishLaunching:(NSNotification *) notification 
{
    NSDictionary* launchOptions = notification.userInfo;
    if (launchOptions == nil) {
        //launchOptions is nil when not start because of notification or url open
        launchOptions = [NSDictionary dictionary];
    }

    [LineAdapter handleLaunchOptions:launchOptions];
}

- (void)login:(CDVInvokedUrlCommand *)command
{
    if (adapter.isAuthorized) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:adapter.MID];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
        return;
    }
    
    if (!adapter.canAuthorizeUsingLineApp) {
        NSLog(@"error Line Login plugin");
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"cannot authorize using line app"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    self.loginCallbackId = command.callbackId;
    [adapter authorize];
}

- (void)authorizationDidChange:(NSNotification *)notification
{
    LineAdapter *lineAdapter = notification.object;
    if (lineAdapter.isAuthorized) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:lineAdapter.MID];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.loginCallbackId];

        self.loginCallbackId = nil;
        return;
    }
    
    NSError *error = notification.userInfo[@"error"];
    if (error) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:error.localizedDescription];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.loginCallbackId];
        self.loginCallbackId = nil;
        return;
    }
}

- (void)logout:(CDVInvokedUrlCommand *)command
{
    [adapter unauthorize];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsString:@"success"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getProfile:(CDVInvokedUrlCommand *)command
{
    if (!adapter.isAuthorized) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"not authorized"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    [adapter.getLineApiClient getMyProfileWithResultBlock:^(NSDictionary *aResult, NSError *aError) {
        if (aError) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:aError.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsDictionary:aResult];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end



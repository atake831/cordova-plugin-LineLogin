#import "LineLogin.h"
#import <LineAdapter/LineAdapter.h>
#import <LineAdapterUI/LineAdapterUI.h>

@interface LineLogin ()
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
        // [self alert:@"Already authorized" message:nil];
        NSLog(@"error Line Login plugin");
        return;
    }
    
    if (!adapter.canAuthorizeUsingLineApp) {
        // [self alert:@"LINE is not installed" message:nil];
        NSLog(@"error Line Login plugin");
        return;
    }
    
    [adapter authorize];
}

- (void)authorizationDidChange:(NSNotification *)notification
{
    LineAdapter *lineAdapter = notification.object;
    if (lineAdapter.isAuthorized) {
        // [self alert:@"Login success!" message:nil];
        NSLog(@"success Line Login plugin");
        return;
    }
    
    NSError *error = notification.userInfo[@"error"];
    if (error) {
        // [self alert:@"Login error!" message:error.localizedDescription];
        NSLog(@"error Line Login plugin");
    }
}

- (void)logout:(CDVInvokedUrlCommand *)command
{
  // TODO:
}

@end


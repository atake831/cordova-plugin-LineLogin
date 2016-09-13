# cordova-plugin-LineLogin

## Install

```
cordova plugin add cordova-plugin-LineLogin
```

your_channel_idを変更して、LineAdapter.plistをxcodeプロジェクトに追加する。

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ChannelId</key>
  <string>your_channel_id</string>
</dict>
</plist>
```

AppDelegate.mを編集。以下を追記する。

```
#import <LineAdapter/LineAdapter.h>
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [LineAdapter handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [LineAdapter handleOpenURL:url];
}
```

## Usage

### Login

```
cordova.plugins.LineLogin.login(
  function(mid){
    // success
  },
  function(){
    // fail
  }
);
```

### Logout

```
cordova.plugins.LineLogin.logout(
  function(){
    // success
  },
  function(){
    // fail
  }
);
```

### Get Profile

```
cordova.plugins.LineLogin.getProfile(
  function(data){
    // success
    //
    // data = {
    //   displayName: 
    //   mid: 
    //   pictureUrl: 
    //   statusMessage: 
    // }
  },
  function(){
    // fail
  }
);
```


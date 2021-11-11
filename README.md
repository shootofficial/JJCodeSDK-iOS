# iOS集成指南

### 简介
[极简验证](https://www.jijiancode.com/)一种全新的手机号验证方式，基于微信的手机号验证方式，告别短信验证时代，更安全、更方便、更快捷、更便宜，每天赠送200次免费验证。
该项目包含iOS接入SDK和相关Demo。

### 集成前必读：

由于微信小程序和APP交互的限制，APP调起小程序要求APP必须在微信开放平台已经认证，如果没有认证无法调起微信小程序，集成前请先前往[微信开放平台](https://open.weixin.qq.com/)进行认证。如果已经集成过微信登录、微信支付或者微信的分享则可以直接使用。

### 一、集成 SDK

> **注：SDK最低要求 iOS 9.0，如果您的项目最低支持版本低于 iOS 9.0，请先升级项目。Objective-C 和 Swift均支持。**

#### 方式一：CocoaPods

``` ruby
pod 'JijiancodeSDK', '~> 1.1.0'
```

#### 方式二：手动集成

1. 前往 [JijiancodeSDK](https://github.com/shootofficial/JJCodeSDK-iOS)下载
2. 找到项目中的 `JijiancodeSDK` 目录，将其复制到项目的根目录下


### 二、配置 `APP_ID` 和 微信 `APP_ID`

找到项目中的`Info.plist`, 增加以下配置:

``` xml
<key>com.jijiancode.APP_ID</key>
<string>JIJIANCODE_APP_ID</string>

<key>com.jijiancode.WX_APP_ID</key>
<string>WX_APP_ID</string>
```

> **请将 JIJIANCODE_APP_ID 替换成 JiJianCode 为应用分配的 AppId , 请将WX_APP_ID 替换成 微信分配的 AppId**

### 三、初始化

#### Objective-C

参考以下代码完成配置JJCodeSDK:

***AppDelegate.h***

``` objc
@interface AppDelegate : UIResponder <UIApplicationDelegate, JJCodeDelegate, WXApiDelegate>
@property (strong, nonatomic) UIWindow * window;
@end
```

***AppDelegate.m***
``` objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JJCode startInit:self];

    // 其他初始化代码
    [WXApi registerApp:@"wx522437950f35xxxx" universalLink:@"https://www.xxxxx.com/ulink/"];
    return YES;
}

// 必须实现，直接参考复制以下代码即可
- (void)jjCodeDidLaunchMiniProgram:(NSString *)reqUserName
                           reqPath:(NSString *)reqPath
                     reqCompletion:(void (^)(BOOL))reqCompletion {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = reqUserName;
    launchMiniProgramReq.path = reqPath;
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        reqCompletion(success);
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [JJCode handleSchemeLinkURL:url];
    // 其他处理代码
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [JJCode handleSchemeLinkURL:url];
    // 其他处理代码
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    [JJCode handleUniversalLink:userActivity];
    // 其他处理代码
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

// 必须实现，直接参考复制以下代码即可
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        WXLaunchMiniProgramResp* miniResp = (WXLaunchMiniProgramResp *)resp;
        [JJCode handleWXResp:miniResp.extMsg];
    }
}
```

### 四、启动验证流程

在需要对手机号验证时，调用`JJCode.verify`启动验证，在启动验证之前，建议根据业务逻辑先对手机号的合法性进行校验。

#### Objective-C

``` objc
    [JJCode verify:phoneNumber success:^(NSString * _Nonnull mobile, NSString * _Nonnull token) {
        NSString* info = [NSString stringWithFormat:@"success mobile: %@, token: %@", mobile, token];
        [self showAler:@"Success" :info];
    } fail:^(NSInteger code, NSString * _Nonnull message) {
        NSString* errorInfo = [NSString stringWithFormat:@"fail code: %ld, message: %@", code, message];
        [self showAler:@"Fail" :errorInfo];
    }];
```

### 五、提交后端进行校验

由于客户端不是完全可信的环境，在上一步验证成功后，在注册或者登录提交数据时，需要将验证返回的`mobile`和`token`全部提交到后端，由后端调用我们提供的`API`校验是否手机号已真实的校验通过。

### 六、控制台配置BundleID和TeamID信息

为了防止`APP_ID`被非法冒用引起不必要的麻烦，强烈建议在我们控制台配置应用Bundle ID和TeamID信息; TeamID 可以配置多个，Bundle ID只能配置一个。TeamID可以登录[Apple开发者后台](https://developer.apple.com/account/#!/membership)获取。

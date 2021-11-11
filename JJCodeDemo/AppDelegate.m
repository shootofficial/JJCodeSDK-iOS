//
//  AppDelegate.m
//  JJCodeDemo
//
//  Created by Shoot on 2021/11/10.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JJCode startInit:self];
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"WeChatSDK: %@", log);
    }];
    
    [WXApi registerApp:@"wx522437950f35xxxx" universalLink:@"https://www.xxxxx.com/ulink/"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)jjCodeDidLaunchMiniProgram:(NSString *)reqUserName
                           reqPath:(NSString *)reqPath
                     reqCompletion:(void (^)(BOOL))reqCompletion {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = reqUserName;
    launchMiniProgramReq.path = reqPath;
//        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeTest;
//        launchMiniProgramReq.miniProgramType = WXMiniProgramTypePreview;
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;

    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        reqCompletion(success);
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [JJCode handleSchemeLinkURL:url];
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [JJCode handleSchemeLinkURL:url];
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSURL * webpageURL = [userActivity webpageURL];
    NSLog(@"handleOpenUniversalLink....%@: ", [webpageURL absoluteString]);
    [JJCode handleUniversalLink:userActivity];
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]) {
        WXLaunchMiniProgramResp* miniResp = (WXLaunchMiniProgramResp *)resp;
        [JJCode handleWXResp:miniResp.extMsg];
    }
}

@end

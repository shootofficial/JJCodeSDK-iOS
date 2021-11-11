//
//  AppDelegate.h
//  JJCodeDemo
//
//  Created by Shoot on 2021/11/10.
//

#import <UIKit/UIKit.h>
#import "JJCode.h"
#import <WechatOpenSDK/WXApi.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, JJCodeDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow * window;

@end


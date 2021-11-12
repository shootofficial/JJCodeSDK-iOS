//
//  JJCode.h
//  JijiancodeSDK
//
//  Created by Shoot on 2021/11/5.
//  Copyright © 2021 Shoot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JJCodeDelegate<NSObject>
@required
/**
* 打开微信小程序的实现
* @param reqUserName 填入WXLaunchMiniProgramReq所需的userName
* @param reqPath 填入WXLaunchMiniProgramReq所需的path
* @param reqCompletion WXLaunchMiniProgramReq中completion回调结果
*/
- (void)jjCodeDidLaunchMiniProgram:(NSString * _Nonnull)reqUserName
                           reqPath:(NSString * _Nonnull)reqPath
                        reqCompletion:(void (^ _Nullable)(BOOL success))reqCompletion;

@end

/**
* 验证手机号码成功回调block
*/
typedef void (^JJCodeSuccessBlock)(NSString * _Nonnull, NSString * _Nonnull);

/**
* 验证手机号码失败回调block
*/
typedef void (^JJCodeFailBlock)(NSInteger, NSString * _Nonnull);

@interface JJCode : NSObject

+(instancetype _Nonnull) shareInstance;

/**
* 获取当前SDK的版本号
* @return NSString SDK版本号(1.2.0)
*/
+ (NSString * _Nonnull)sdkVersion;

/**
* 初始化JijiancodeSDK
* 调用该方法前，需在Info.plist文件中配置键值对
* <key>com.jijiancode.APP_ID</key>
* <key>com.jijiancode.WX_APP_ID</key>
*/
+ (void)startInit:(id<JJCodeDelegate> _Nonnull)delegate;

/**
* 初始化JijiancodeSDK，必须传入APP_ID 和 WX_APP_ID
* 调用该方法前，需在Info.plist文件中配置键值对
* @param appId JijianCode分配的appId
* @param wxAppId 微信开发者后台分配的wxAppId
*/
+ (void)startInitWith:(id<JJCodeDelegate> _Nonnull)delegate
                appId:(NSString * _Nonnull)appId
              wxAppId:(NSString * _Nonnull)wxAppId;

/**
* 验证手机号码
* @param mobile 需要验证的手机号码
* @param success 成功回调block，在主线程（UI线程）回调
* @param fail 失败回调block，在主线程（UI线程）回调
*/
+ (void)verify:(NSString * _Nonnull)mobile
               success:(JJCodeSuccessBlock _Nullable)success
               fail:(JJCodeFailBlock _Nullable)fail;

/**
* 验证手机号码
* @param mobile 需要验证的手机号码
* @param success 成功回调block，在主线程（UI线程）回调
* @param fail 失败回调block，在主线程（UI线程）回调
@ @param showLoading 是否展示默认Loading
*/
+ (void)verify:(NSString * _Nonnull)mobile
               success:(JJCodeSuccessBlock _Nullable)success
               fail:(JJCodeFailBlock _Nullable)fail
               showLoading:(BOOL)showLoading;
/**
 * 处理微信小程序结果回调
 * @param extMsg WXApiObject.h中WXLaunchMiniProgramResp中的extMsg
 */
+ (BOOL)handleWXResp:(NSString * _Nonnull)extMsg;

/**
 * 处理 URI Schemes 逻辑
 * @param url 通过Schemes调起时，系统回调回来的URL
 * @return bool 是否成功处理
 */
+ (BOOL)handleSchemeLinkURL:(NSURL * _Nullable)url;

/**
 * 处理 Universal link 逻辑
 * @param userActivity 通过Universal link调起时，包含系统回调回来的URL信息的NSUserActivity
 * @return bool 是否成功处理
 */
+ (BOOL)handleUniversalLink:(NSUserActivity * _Nullable)userActivity;

@end



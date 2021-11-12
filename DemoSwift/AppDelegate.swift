//
//  AppDelegate.swift
//  DemoSwift
//
//  Created by Kenneth on 2021/11/11.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        JJCode.startInit(self)
        WXApi.registerApp("wx522437950f3xxxx", universalLink: "https://www.xxxx.com/ulink/")
        WXApi.startLog(by: .detail) { log in
            print("WeChatSDK: \(log)");
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        window?.rootViewController = vc
        return true
    }

}

extension AppDelegate: JJCodeDelegate {
    func jjCodeDidLaunchMiniProgram(_ reqUserName: String, reqPath: String, reqCompletion: ((Bool) -> Void)? = nil) {
        let launchMiniProgramReq = WXLaunchMiniProgramReq.object()
        launchMiniProgramReq.userName = reqUserName
        launchMiniProgramReq.path = reqPath
        launchMiniProgramReq.miniProgramType = .release
        WXApi.send(launchMiniProgramReq) { (result) in
            reqCompletion?(result)
        }
        
    }
}


//
//  AppDelegate.swift
//  BodyBankEnterpriseDemo
//
//  Created by Shunpei Kobayashi on 2018/10/15.
//  Copyright © 2018 Shunpei Kobayashi. All rights reserved.
//

import UIKit
import BodyBankEnterprise

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //For development only
        //Replace admin api url/api key with those provided
        let apiUrl = "API URL"
        let apiKey = "API KEY"
        let tokenProvider = DirectTokenProvider(apiUrl: apiUrl, apiKey: apiKey)
        tokenProvider.userId = "test_usr_id" //Replace this to any user id that is used for the development
        tokenProvider.tokenDuration = 86400 //1 day duration. Please shorten this to test expiry.
        try! BodyBankEnterprise.initialize(tokenProvider: tokenProvider)
        
        
        //For production
//        let tokenProvider = DefaultTokenProvider()
//        tokenProvider.setRestoreTokenBlock { callback in
//            let token = BodyBankToken()
//            // Fetch token from server using Admin API
//            // IMPLEMENT HERE
//            callback(token, nil)
//        }
//        try! BodyBankEnterprise.initialize(tokenProvider: tokenProvider)


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


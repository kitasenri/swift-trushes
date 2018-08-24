//
//  AppDelegate.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?;

    //------------------------------------------------
    // Consts
    //------------------------------------------------

    //------------------------------------------------
    // Lifecycle
    //------------------------------------------------
    /**
     * Create Tab Menu
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // setup tab bar
        self.setupTabBar();
        
        // set useragent for webview.
        self.setupUserAgent();
        
        return true
    }

    /**
     * Custom scheme handler
     */
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        if let tabBarController = self.window?.rootViewController as? UITabBarController {

            if let host : String = url.host as String? {

                //let query : String = url.query as String!
                if ( host == CustomTabBarController.TABINDEX.HOME.schemeValue ) {
                    // show home page
                    tabBarController.selectedIndex = CustomTabBarController.TABINDEX.HOME.rawValue;
                } else if ( host == CustomTabBarController.TABINDEX.MYPAGE.schemeValue ) {
                    // show mypage
                    tabBarController.selectedIndex = CustomTabBarController.TABINDEX.MYPAGE.rawValue;
                }

            }
            
        }
        
        self.window?.makeKeyAndVisible();
        return true;
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

    //------------------------------------------------
    // Process Method
    //------------------------------------------------
    /**
     * Setup Tab Bar and X button.
     */
    func setupTabBar() {
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.backgroundColor = UIColor.white;
        window?.rootViewController = CustomTabBarController();
        window?.makeKeyAndVisible();
    }
    
    /**
     * Setup useragent for wkwebview.
     */
    func setupUserAgent() {
        
        // set useragent for WKWebView
        UserDefaults.standard.register(defaults: [
            "UserAgent" : CommonUtils.createUserAgent()
        ]);
        
    }
    
}


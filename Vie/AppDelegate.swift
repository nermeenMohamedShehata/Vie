//
//  AppDelegate.swift
//  Vie
//
//  Created by Nerneen Mohamed on 12/6/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
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
//MARK: - DynamicLink with Firebase
extension AppDelegate {
    func handleIncomingDynamicLink(_ dynamicLink:DynamicLink){
        guard let url = dynamicLink.url else{
            print("That's weird. My dynamic link object has no url")
            return
        }
        print("your incoming url is \(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else {return}
        for queryItem in queryItems{
            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
        }
    }
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity,restorationHandler: @escaping ([Any?]) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled{
                return true
            }else{
                //Maybe do other things with our URL?
                return false
            }
        }
        return false
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received a URL through a custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url){
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }else{
            //Maybe handle Google - Facebook signin here.
            return false
        }
    }
}

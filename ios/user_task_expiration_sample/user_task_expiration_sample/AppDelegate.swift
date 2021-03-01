//
//  AppDelegate.swift
//  user_task_expiration_sample
//
//  Created by Eric Lanz on 2/26/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // EMBRACE HINT
        // This is where we start our background task. The beginBackgroundTask call gets us permission
        // to continue running in the background.
        print("enter background, start user task:");
        UIApplication.shared.beginBackgroundTask(withName:"MyBackgroundTask_1", expirationHandler: {() -> Void in
            print("expiration handler called")
        })
        // To simulate real background work we run a timer and print out a simple counter
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            count+=1
            print("doing background work: \(count)");
        }
        // This task is our control, we will end this task after 1 second normally
        let identifier = UIApplication.shared.beginBackgroundTask(withName:"MyBackgroundTask_2", expirationHandler: {() -> Void in
            
        })
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
            UIApplication.shared.endBackgroundTask(identifier)
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


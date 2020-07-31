//
//  AppDelegate.swift
//  sample_integration
//
//  Created by Juan Pablo on 30/07/2020.
//  Copyright © 2020 Embrace.io. All rights reserved.
//

import UIKit
// EMBRACE HINT:
// Embrace is integrated using cocoapods.  If you just downloaded the project and it is failing to build, simply run
// 'pod update' from the root of the project in terminal,  See: https://docs.embrace.io/docs/ios-integration-guide
// Additionally open the 'Embrace-Info.plist' file and fill in your own API_KEY
// Make sure to look at the 'Embrace Symbol Upload' build phase to learn about dsyms and symbolication
import Embrace

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // EMBRACE HINT:
        // Embrace can use either objective-c or swift style logging.  To enable swift style logging set this flag to true
        // This can be done before calling start to ensure all logging is in the the clean format
        Embrace.sharedInstance().setCleanLogsEnabled(true)
                
        // EMBRACE HINT:
        // Always initialize Embrace as early as possible and in-line with the launch methods your application is using
        // Embrace can't measure what it can't see, so initializing as early as possible gets you the most information to work with.
        // Notice if you include your API_KEY in the Embrace-Info.plist file you don't have to also include it here.
        //
        // Note: If you want to also use other reporting system such as Crashlytics, that's ok!  Just make sure to initialize Embrace
        // first so we can ensure our compatibility with Crashlytics.  Also set 'CRASH_REPORT_ENABLED' to 'NO' in Embrace-Info.plist if
        // you want to use a separate crash reporting system.
        Embrace.sharedInstance().start(launchOptions: launchOptions)
                
        // EMBRACE HINT:
        // Always remember to end the startup moment.  This is the best way to measure app launch performance and abandonment.
        // Make sure to call this function when your actual app launch is finished, so if you are loading UI or other data wait
        // to call this until you are finished.
        Embrace.sharedInstance().endAppStartup();
                
        // EMBRACE HINT:
        // Embrace's platform is built around user sessions.  Finding your users when they have a problem requires that Embrace knows some
        // unique information about your user.  We recommend sharing an anonymized version of your internal user id.  This way your
        // users will appear in searches when you look, while Embrace will not be able to link sessions back to specific users -- only you can.
        Embrace.sharedInstance().setUserIdentifier("internal_user_id_1234");
        Embrace.sharedInstance().setUsername("hugarmy");
        Embrace.sharedInstance().setUserEmail("hugarmy@embrace.io");
            
        // EMBRACE HINT:
        // If your user logs out, or for multi-tenet applications you can also clear these settings at any time:
        Embrace.sharedInstance().clearUsername();
        Embrace.sharedInstance().clearUserEmail();
                
        // EMBRACE HINT:
        // Session properties are a great way to keep track of additional information about this session or this device.  For example if your
        // application runs on kiosk hardware in retail stores, you could add the store id as a permanent property.  Now you can filter and
        // search based on your deployed locations.
        // In this example we're tracking the way the application was launched, we want to know which sessions are the result of a push notification.
        Embrace.sharedInstance().addSessionProperty("normal", withKey: "launch type", permanent: false)
                
        // EMBRACE HINT:
        // Session properties defined as permanent persist across app launch.  This means you can read those properties back and use them for
        // application logic.
        print("session properties: \(String(describing: Embrace.sharedInstance().getSessionProperties()))")
                
        // EMBRACE HINT:
        // As you can see from this project, Embrace is much more than just a simple crash tracker.  If you do want to try out
        // Embrace's crash tracking capabilities, simply uncomment the below dispatch call.  Ensure that you run your application on
        // real hardware, without Xcode running, to ensure the crash is captured correctly.
        // see: https://docs.embrace.io/docs/crash-debugging for more information
        //        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        //            Embrace.sharedInstance().crash()
        //        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // EMBRACE HINT:
        // Here we set the 'launch type' session property to notification since we now know this is a notification launch.
        // properties with the same key overwrite each other.
        Embrace.sharedInstance().addSessionProperty("notification", withKey: "launch type", permanent: false)
        completionHandler(.noData)
    }
}


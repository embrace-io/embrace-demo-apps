//
//  AppDelegate.swift
//  sample_integration
//
//  Created by Eric Lanz on 6/4/20.
//  Copyright © 2020 Embrace. All rights reserved.
//

import UIKit
// EMBRACE HINT:
// Embrace is integrated using cocoapods.  If you just downloaded the project and it is failing to build, simply run
// 'pod update' from the root of the project in terminal,  See: https://docs.embrace.io/docs/ios-integration-guide
// Additionally open the 'Embrace-Info.plist' file and fill in your own API_KEY
// Make sure to look at the 'Embrace Symbol Upload' build phase to learn about dsyms and symbolication
import Embrace
import LocalFrameworkDependency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



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
        
        let localMain = LocalFrameworkMain()
        print("result = \(localMain.calculateSomething(78, y: 32))");
        
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
//            Embrace.sharedInstance()?.crash()
//        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        // EMBRACE HINT:
        // Here we set the 'launch type' session property to notification since we now know this is a notification launch.
        // properties with the same key overwrite each other.
        Embrace.sharedInstance().addSessionProperty("notification", withKey: "launch type", permanent: false)
        completionHandler(.noData)
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


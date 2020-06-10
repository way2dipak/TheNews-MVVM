//
//  AppDelegate.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0
        registerNotifications(application: application)
        //registerForPushNotification(application: application)
        GIDSignIn.sharedInstance()?.clientID = Global.shared.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        setRootController()
        return true
    }
}

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url))!
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error  = error {
            print(error.localizedDescription)
            return
        } else {
            setRootController()
            Global.shared.userObj = UserModel(userId: user.userID, idToken: user.authentication.idToken, fullName: user.profile.name, givenName: user.profile.givenName, familyName: user.profile.familyName, email: user.profile.email, image: user.profile.imageURL(withDimension: 35)!.absoluteString)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().signOut()
        setRootController()
    }
    
    func setRootController() {
        let rootController : UINavigationController
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            if GIDSignIn.sharedInstance()?.currentUser == nil {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
                return
            }
            let vc = StoryBoardManager.shared.getStoryboard(name: .SetUp).instantiateViewController(withIdentifier: SetUpViewController.identifier) as! SetUpViewController
            rootController = UINavigationController(rootViewController: vc)
            rootController.isNavigationBarHidden = true
        }
        else {
            let vc = StoryBoardManager.shared.getStoryboard(name: .Login).instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
            rootController = UINavigationController(rootViewController: vc)
            rootController.isNavigationBarHidden = true
        }
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK: Push notifications handling
    private func registerNotifications(application: UIApplication) {
        let userNotification = UNUserNotificationCenter.current()
        userNotification.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound]
        userNotification.requestAuthorization(options: options) { (isAuthorized, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if isAuthorized {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
                else {
                    print("UnAuthorized!!")
                }
            }
        }
    }
    
    //MARK: Fetch the device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokens = deviceToken.map {
            return String(format: "%02.2hhx", $0)
        }
        let token = deviceTokens.joined()
        print("\n\ndevice token ", token, "\n\n")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //MARK: Failed to fetch remote notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to fetch device tokens", error.localizedDescription)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo1: \(userInfo)")
        //deeplink code goes here..
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
      print("userInfoWillPresent: \(userInfo)")
      completionHandler([.alert, .sound])
    }
    
}

extension AppDelegate: MessagingDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo2: ", userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfoWithFetchhandler: ", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FcmToken: ", fcmToken)
        let dataDict: [String:String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    
}

/*
extension AppDelegate {
    func registerForPushNotification(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("userInfo: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("userInfo1: \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
         Messaging.messaging().apnsToken = deviceToken
    }
    
    
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print("userInfoWillPresent: \(userInfo)")

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print("userInfoWillPresent1: \(userInfo)")

    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
//        DispatchQueue.main.async {
//            Messaging.messaging().subscribe(toTopic: "/topics/all")
//        }
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

*/

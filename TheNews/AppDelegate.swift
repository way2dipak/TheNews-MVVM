//
//  AppDelegate.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance()?.clientID = "158956149929-mssrkg88kb4j7r93cioi9ivp14roil9h.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
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
            Global.shared.userObj = UserModel(userId: user.userID, idToken: user.authentication.idToken, fullName: user.profile.name, givenName: user.profile.givenName, familyName: user.profile.familyName, email: user.profile.email, image: user.profile.imageURL(withDimension: 30)!.absoluteString)
            setRootController()
        }
    }
    
    func setRootController() {
        let rootController : UINavigationController
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            if GIDSignIn.sharedInstance()?.currentUser == nil {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
                return
            }
            let vc = StoryBoardManager.shared.getStoryboard(name: .DashBoard).instantiateViewController(withIdentifier: DashBoardTabController.identifier) as! DashBoardTabController
            rootController = UINavigationController(rootViewController: vc)
            rootController.isNavigationBarHidden = true
        }
        else {
            let vc = StoryBoardManager.shared.getStoryboard(name: .Main).instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
            rootController = UINavigationController(rootViewController: vc)
            rootController.isNavigationBarHidden = true
        }
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    }
}

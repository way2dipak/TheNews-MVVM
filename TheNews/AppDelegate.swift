//
//  AppDelegate.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
//            window?.overrideUserInterfaceStyle = .dark
        }
        return true
    }
}

extension AppDelegate {
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
    
    var rootNavigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }
    
    var firstViewController: UIViewController? {
        return rootNavigationController?.viewControllers.first
    }
    
    func push(to vc: UIViewController, animated: Bool = true) {
        var navigationController: UINavigationController?
        
        if let navControllerVC = rootNavigationController {
            navigationController = navControllerVC
        } else {
            navigationController = rootViewController?.navigationController
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func present(to vc: UIViewController, animated: Bool = true) {
        var navigationController: UINavigationController?
        
        if let navControllerVC = rootNavigationController {
            navigationController = navControllerVC
        } else {
            navigationController = rootViewController?.navigationController
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func displayUsageUI() {
        let window = UIApplication.shared.keyWindow!
        let usageNIB = UsageExceeded.instanceFromNib()
        usageNIB.frame = window.bounds
        usageNIB.btnHandler = { [weak self] in
            guard let self = self else { return }
            let vc = StoryBoardManager.shared.getStoryboard(name: .Account).instantiateViewController(withIdentifier: AccountVC.identifier) as! AccountVC
            self.present(to: vc, animated: true)
        }
        usageNIB.alpha = 0
        window.addSubview(usageNIB)
        UIView.animate(withDuration: 0.3) {
            usageNIB.alpha = 1
        }
    }
    
}

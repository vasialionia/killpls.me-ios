//
//  AppDelegate.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var rootViewController: SideViewController {
        
        let articlesViewController = ArticlesViewController()
        let menuViewController = MenuViewController()
        let sideViewController = SideViewController(mainViewController: articlesViewController, sideViewController: menuViewController)
        
        menuViewController.onTagTap = { [weak articlesViewController, weak sideViewController] (tag: String?) in
            articlesViewController?.tag = tag
            sideViewController?.setMainViewActive(active: true, animated: true)
        }
        
        return sideViewController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        GAI.sharedInstance().trackerWithTrackingId("123")
        
        return true
    }
}

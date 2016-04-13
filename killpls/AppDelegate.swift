//
//  AppDelegate.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

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

        Fabric.with([Crashlytics.self])

        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        return true
    }
}

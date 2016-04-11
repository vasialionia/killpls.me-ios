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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window!.rootViewController = SideViewController(mainViewController: ArticlesViewController(), sideViewController: UIViewController())
        window!.makeKeyAndVisible()
        
        return true
    }
}

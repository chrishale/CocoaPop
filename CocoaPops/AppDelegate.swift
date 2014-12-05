//
//  AppDelegate.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow = {
        let win = UIWindow(frame: UIScreen.mainScreen().bounds)
        win.backgroundColor = UIColor.clearColor()
        win.rootViewController = ViewController()
        return win
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        window.makeKeyAndVisible()
        return true
    }
    
    
}


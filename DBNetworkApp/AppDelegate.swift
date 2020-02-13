//
//  AppDelegate.swift
//  DBNetworkApp
//
//  Created by Nitin A on 15/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBNetworkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        let controller = ViewController()
        let navigation = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        return true
    }
}


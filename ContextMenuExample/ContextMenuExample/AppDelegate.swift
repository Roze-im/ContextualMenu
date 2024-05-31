//
//  AppDelegate.swift
//  ContextMenuExample
//
//  Created by Thibaud David on 06/02/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow()
        self.window = window

        window.rootViewController = ViewController()
        window.makeKeyAndVisible()

        return true
    }
}


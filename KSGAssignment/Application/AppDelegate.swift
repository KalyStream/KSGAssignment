//
//  AppDelegate.swift
//  KSGAssignment
//
//  Created by Kalybay Zhalgasbay on 18.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainAssembly = MainAssembly()
        let main = mainAssembly.makeMainModule()
        let navigationViewController = UINavigationController(rootViewController: main)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationViewController
        return true
    }
}


//
//  AppDelegate.swift
//  TaskList
//
//  Created by Ilya Zemskov on 02.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var storageManager = StorageManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }
}


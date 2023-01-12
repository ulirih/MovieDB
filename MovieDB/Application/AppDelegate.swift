//
//  AppDelegate.swift
//  MovieDB
//
//  Created by andrey perevedniuk on 21.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator : AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navConrolller = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navConrolller)
        appCoordinator!.start()
        
        window?.rootViewController = navConrolller
        window?.makeKeyAndVisible()
        
        return true
    }
}


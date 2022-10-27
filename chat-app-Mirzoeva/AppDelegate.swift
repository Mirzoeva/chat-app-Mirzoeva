//
//  AppDelegate.swift
//  chat-app-Mirzoeva
//
//  Created by Ума Мирзоева on 23.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let coreDataStack = NewCoreDataService()
        let channelsPresenter = ChannelsPresenterImpl(coreDataStack: coreDataStack)
        window?.rootViewController = UINavigationController(rootViewController: ChannelsViewController(nibName: nil, bundle: nil, coreDataStack: coreDataStack, presenter: channelsPresenter))
        window?.makeKeyAndVisible()
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme)
        FirebaseApp.configure()
        return true
    }
}


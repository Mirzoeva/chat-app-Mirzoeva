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
    private var lastState: UIApplication.State = .inactive
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let coreDataStack = NewCoreDataService()
        let channelsPresenter = ChannelsPresenterImpl(coreDataStack: coreDataStack)
        window?.rootViewController = UINavigationController(rootViewController: ChannelsViewController(nibName: nil, bundle: nil, coreDataStack: coreDataStack, presenter: channelsPresenter))
        window?.makeKeyAndVisible()
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme)
        Logger.fullLog(from: "Not Running", to: "Inactive", function: #function)
        lastState = UIApplication.shared.applicationState
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Logger.log(function: #function)
        return true
    }
    
    // MARK: - Launch
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.fullLog(from: "Background", to: "Inactive", function: #function)
        lastState = UIApplication.State.inactive
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        printState(#function)
    }
    
    // MARK: - Termination
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.fullLog(from: "Suspended", to: "Not Running", function: #function)
        lastState = UIApplication.shared.applicationState
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.fullLog(from: "Active", to: "Inactive", function: #function)
        lastState = UIApplication.State.inactive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        printState(#function)
    }
    
    private func printState(_ function: String) {
        Logger.fullLog(from: lastState.name, to: UIApplication.shared.applicationState.name, function: function)
        lastState = UIApplication.shared.applicationState
    }
}

private extension UIApplication.State {
    var name: String {
        switch self {
        case .inactive:
            return "Inactive"
        case .background:
            return "Background"
        case .active:
            return "Active"
        @unknown default:
            return "Unknown"
        }
    }
}


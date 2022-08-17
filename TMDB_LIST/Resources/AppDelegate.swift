//
//  AppDelegate.swift
//  TMDB_LIST
//
//  Created by ohisea on 2022/08/12.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    enum Identifiers {
      static let viewAction = "VIEW_IDENTIFIER"
      static let newsCategory = "CustomSamplePush"
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForPushNotificatinos()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device token is: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
}

extension AppDelegate {
    func registerForPushNotificatinos() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                let viewAction = UNNotificationAction(
                    identifier: AppDelegate.Identifiers.viewAction,
                    title: "View",
                    options: [.foreground])

                let newsCategory = UNNotificationCategory(
                    identifier: AppDelegate.Identifiers.newsCategory,
                    actions: [viewAction],
                    intentIdentifiers: [],
                    options: [])
                
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings {
            print("cmk notificatin Settings: \($0)")
            
            guard $0.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

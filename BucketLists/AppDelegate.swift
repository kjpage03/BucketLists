//
//  AppDelegate.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        
                let completeAction = UNNotificationAction(identifier: "Complete", title: "Mark as complete", options: [])
        
        let remindAction = UNNotificationAction(identifier: "Remind", title: "Remind me later", options: [])
                let bucketCategory = UNNotificationCategory(identifier: "Actions", actions: [completeAction, remindAction], intentIdentifiers: [], options: [])
        
                center.setNotificationCategories([bucketCategory])
                center.delegate = self
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            if response.actionIdentifier == "Complete" {
                let dataController = DataController()
                var bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
                
                for (index1, bucketList) in bucketLists.enumerated() {
                    for (index2, item) in bucketList.items.enumerated() {
                        if item.id.uuidString == response.notification.request.identifier {
                            bucketLists[index1].items[index2].isComplete = true
                            print(bucketLists[index1].items[index2])
                        }
                    }
                }
                
                dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            } else if response.actionIdentifier == "Remind" {
                let id = UUID()
                let name = ItemName.listItemName
                
                let content = UNMutableNotificationContent()
                content.title = "Bucket List Reminder"
                content.body = "\(name)"
                content.sound = UNNotificationSound.default
                content.categoryIdentifier = "Actions"
        
                let triggerDateComponents =
                   Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: Date())
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
                UNUserNotificationCenter.current().add(request)
            }
            completionHandler()
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


}


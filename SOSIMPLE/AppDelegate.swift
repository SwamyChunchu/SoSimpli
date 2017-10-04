//
//  AppDelegate.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var profileDataDic = NSDictionary()
    var startTripString = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
         UIApplication.shared.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
                let userID = UserDefaults.standard.object(forKey: "success")
                if (userID == nil)
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let navigationController = self.window?.rootViewController as! UINavigationController
                    navigationController.pushViewController(destinationViewController, animated: false)
                }else
                {
                    if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        let navigationController = self.window?.rootViewController as! UINavigationController
                        navigationController.pushViewController(destinationViewController, animated: false)
                    }
                    else
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        let navigationController = self.window?.rootViewController as! UINavigationController
                        navigationController.pushViewController(destinationViewController, animated: false)
                    }
                }

        
        self.registerPushNotifications()
        
        return true
    }
    
    func registerPushNotifications()
    {
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler:
                { granted, error in
                if granted {
                
                    UIApplication.shared.registerForRemoteNotifications()
                    
                } else {
                        // Unsuccessful...
                           }
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    
    //MARK: Get Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        deviceTokenString = String(deviceTokenString.replacingOccurrences(of: " ", with: ""))
        UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
        print(deviceTokenString)
        
//        let token = deviceToken.map({ String(format: "%02.2hhx", $0)}).joined()
//        print("TOKEN: " + token)
    }
    // Called when APNs failed to register the device for push notifications
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
    }

    
    //MARK: Push Notification Methods
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
          print(response.notification.request.content.userInfo)
        _ = response.notification.request.content.userInfo as NSDictionary
        
        let userID = UserDefaults.standard.object(forKey: "success")
        if (userID == nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.pushViewController(destinationViewController, animated: false)
        }else
        {
            if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
         print(notification.request.content.userInfo)
        let dic = notification.request.content.userInfo as NSDictionary
        print(dic)
//      if let aps = dic["aps"] as? [String: Any] {
//      print(aps)
//      }
        
        let userID = UserDefaults.standard.object(forKey: "success")
        if (userID == nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navigationController = self.window?.rootViewController as! UINavigationController
            navigationController.pushViewController(destinationViewController, animated: false)
        }else
        {
            if UserDefaults.standard.object(forKey: "success") as! String == "LoginSuccess"
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = self.window?.rootViewController as! UINavigationController
                navigationController.pushViewController(destinationViewController, animated: false)
            }
        } 
    }
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    

// MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SOSIMPLE")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }

        } else {
            // Fallback on earlier versions
        }
    }

}

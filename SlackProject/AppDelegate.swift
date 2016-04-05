//
//  AppDelegate.swift
//  SlackProject
//
//  Created by Stephen Grinich on 4/4/16.
//  Copyright © 2016 Stephen Grinich. All rights reserved.
//
// Some data methods based from this tutorial: http://www.appcoda.com/core-data-preload-sqlite-database/

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
            print("preloading")
            preloadData()
            defaults.setBool(true, forKey: "isPreloaded")
        }
    
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sgrinich.SlackProject" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SlackProject", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func parseJSON (contentsOfURL: NSURL, encoding: NSStringEncoding) -> [(username:String, realname:String, title: String, image: NSData)]? {
        // Load the JSON file and parse it
        var items:[(username:String, realname:String, title: String, image: NSData)]?

        
        do {
            let content = try String(contentsOfURL: contentsOfURL, encoding: encoding)
            if let dataFromString = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                
                items = []
                
                for member in json["members"].arrayValue
                {
                    
                    let userProfile = member["profile"]

//     
//                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                   
////                        
////                                                slackProfile.setInitialValues(username, realname: realname, title: title, image: profileImage!)
////                                                self.profileList.append(slackProfile)
//                    })
//                    
                    
                    
                    
                    let imageURL = userProfile["image_192"].stringValue
                    let imageData = NSData(contentsOfURL: NSURL(string:imageURL)!)!
//                    var profileImage =  UIImage(data: data!)
                    
                    
                    let item = (username: member["name"].stringValue, realname: member["real_name"].stringValue, title: userProfile["title"].stringValue, image: imageData)
                    
                    items?.append(item)
                    
                    
                }
                
                
                
            }
        } catch {
            print(error)
        }
        
        
        return items
    }
    
   
    func preloadData () {
        // Retrieve data from the source file
        
        guard let remoteURL = NSURL(string: "https://slack.com/api/users.list?token=xoxp-4698769766-4698769768-18910479235-8fa82d53b2&pretty=1") else {
            return
        }

        removeData()

            if let items = parseJSON(remoteURL, encoding: NSUTF8StringEncoding) {
                // Preload the menu items
                    for item in items {
                        let slackItem = NSEntityDescription.insertNewObjectForEntityForName("SlackItem", inManagedObjectContext: managedObjectContext) as! SlackItem
                        
                        slackItem.username = item.username
                        slackItem.realname = item.realname
                        slackItem.title = item.title
                        slackItem.image = item.image
                        
                        do {
                            try managedObjectContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                
            }
        
    }
    
    func removeData () {
        // Remove the existing items
         let managedObjectContext = self.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "SlackItem")
            var e: NSError?
        do {
            let slackItems =
            try managedObjectContext.executeFetchRequest(fetchRequest)

            for item in slackItems {
                managedObjectContext.deleteObject(item as! NSManagedObject)
            }

        
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        

        
    }

}


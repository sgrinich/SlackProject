//
//  ProfileTableViewController.swift
//  SlackProfile
//
//  Created by Stephen Grinich on 4/1/16.
//  Copyright © 2016 Stephen Grinich. All rights reserved.
//

import UIKit
import CoreData


class ProfileTableViewController: UITableViewController {
    
    var profileList = [SlackProfile]()
    var slackProfiles = [NSManagedObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let slackProfile = SlackProfile()
        let imate = UIImage()
        slackProfile.setInitialValues("stephen", realname: "stephen", title: "butterflyer", image: imate)
        print("made slack proifle")
        saveProfile(slackProfile)
        
        print("before 1")
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        print("1 done")
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "SlackProfile")
        print("2 done")
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            slackProfiles = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        print("3 done")
        
//        getSlackJSON()
        
        

    }
    
    func getSlackJSON(){
        let urlString = "https://slack.com/api/users.list?token=xoxp-4698769766-4698769768-18910479235-8fa82d53b2&pretty=1"
        let urlEncodedString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL( string: urlEncodedString!)
        var task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, innerError) in
            let json = JSON(data: data!)
            
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                // do some task
                
                for member in json["members"].arrayValue
                {
                    print("test")
                    let realname = member["real_name"].stringValue
                    let username = member["name"].stringValue
                    
                    let userProfile = member["profile"]
                    let title = userProfile["title"].stringValue
                    
                    
                    let slackProfile = SlackProfile()
                    let imate = UIImage()
                    slackProfile.setInitialValues(username, realname: realname, title: title, image: imate)
//                    self.profileList.append(slackProfile)
                    self.saveProfile(slackProfile)
                
                    
                }

                
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    self.tableView.reloadData()

                }
            }
            
            
            
//            dispatch_async(dispatch_get_main_queue(), {
//                for member in json["members"].arrayValue
//                {
//                    print("test")
//                    let realname = member["real_name"].stringValue
//                    let username = member["name"].stringValue
//                    
//                    let userProfile = member["profile"]
//                    let title = userProfile["title"].stringValue
//                    
//                    
//                    let slackProfile = SlackProfile()
//                    let imate = UIImage()
//                    slackProfile.setInitialValues(username, realname: realname, title: title, image: imate)
//                    self.profileList.append(slackProfile)
//                    
////                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
////                        let imageURL = userProfile["image_192"].stringValue
////                        let data = NSData(contentsOfURL: NSURL(string:imageURL)!)
////                        var profileImage =  UIImage(data: data!)
////                        
////                        slackProfile.setInitialValues(username, realname: realname, title: title, image: profileImage!)
////                        self.profileList.append(slackProfile)
////                    })
//                    
//                    
//                    
//                
//                }
//                dispatch_async(dispatch_get_main_queue(),{
//                    self.tableView.reloadData()
//                })
//            })
            
            
            
        }
        task.resume()
    }
    
    
    func saveProfile(givenProfile: SlackProfile) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print("Save 1 done")
        
        let managedContext = appDelegate.managedObjectContext
        
        print("before 2")
        
        //2
        let entity =  NSEntityDescription.entityForName("SlackProfile",
            inManagedObjectContext:managedContext)

        
        let profile = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        print("Save 2 done")
        
        //3
        profile.setValue(givenProfile.username, forKey: "username")
        profile.setValue(givenProfile.realname, forKey: "realname")
        profile.setValue(givenProfile.title, forKey: "title")
//        profile.setValue(givenProfile.image, forKey: "image")
        
        print("Save 3 done")
        
        //4
        do {
            try managedContext.save()
            //5
            slackProfiles.append(profile)
            print("successfully saved a slack profile")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return profileList.count
        return slackProfiles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProfileTableViewCell
//        let profile = self.profileList[indexPath.row] as! SlackProfile
        let profile = self.slackProfiles[indexPath.row]
        cell.usernameLabel.text = profile.valueForKey("username") as? String

        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
}

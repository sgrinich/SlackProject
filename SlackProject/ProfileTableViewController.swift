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
    
    var slackItems:[SlackItem] = []



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "SlackItem")
            do {
                slackItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [SlackItem]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        // Need this so images load in TableViewCells right away
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            })
        

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slackItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProfileTableViewCell

        let profile = self.slackItems[indexPath.row]
        
        let image : UIImage = UIImage(data: profile.image!)!

        cell.usernameLabel.text = profile.username
        cell.profileImage.image = image
        
//        cell.setNeedsLayout()
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
}

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
        
        // Get Slack items out of saved data
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "SlackItem")
            do {
                slackItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [SlackItem]
                
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
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

        cell.usernameLabel.text = profile.realname
        cell.profileImage.image = image
        cell.profileImage.layer.cornerRadius = cell.profileImage.layer.frame.width / 2
        cell.profileImage.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Handles transition to detail view
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("profileViewController") as! ProfileViewController
        let profile = self.slackItems[indexPath.row]
        destination.slackItem = profile
        
        navigationController?.pushViewController(destination, animated: true)


    }
    
    
    
    
    
    
    
    
    
    

    
    
    
}

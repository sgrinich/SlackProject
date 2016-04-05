//
//  SlackItem.swift
//  CoreDataPreloadDemo
//
//  Created by Stephen Grinich
//  Copyright (c) 2015 sgrinich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SlackItem: NSManagedObject {
    @NSManaged var username:String?
    @NSManaged var realname:String?
    @NSManaged var title:String?
    @NSManaged var image:NSData?
    
}
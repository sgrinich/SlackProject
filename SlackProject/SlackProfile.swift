//
//  SlackProfile.swift
//  SlackExercise
//
//  Created by Stephen Grinich on 3/29/16.
//  Copyright © 2016 Stephen Grinich. All rights reserved.
//


//On the individual profile page, you should show the person's picture, username, real name, and title. Other profile fields are optional.


import Foundation
import UIKit

class SlackProfile {
    
    var username:String = "";
    var realname:String = "";
    var title:String = "";
    var image = UIImage();
    
    func setInitialValues(username:String, realname:String, title:String, image:UIImage){
        self.username = username;
        self.realname = realname;
        self.title = title;
        self.image = image;
    }
    
    
    
}
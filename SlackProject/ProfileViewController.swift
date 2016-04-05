//
//  ProfileViewController.swift
//  SlackProject
//
//  Created by Stephen Grinich on 4/5/16.
//  Copyright © 2016 Stephen Grinich. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate  {
    

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var realnameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var phonenumber: String?
    var email: String?
    
    @IBOutlet weak var phonebutton: UIButton!
    @IBOutlet weak var emailbutton: UIButton!
    
    var slackItem : SlackItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let profile = slackItem {
            
            self.navigationItem.title = ""
            
            titlelabel.text = profile.title
            
            let image : UIImage = UIImage(data: profile.image!)!
            profileImage.image = image
            profileImage.layer.cornerRadius = 15
            realnameLabel.text = profile.realname
            usernameLabel.text = "@" + profile.username!
            phonenumber = profile.phone
            email = profile.email

            if phonenumber! == ""{
                phonebutton.hidden = true
            }
            
            if email! == "" {
                emailbutton.hidden = true
            }
            
            
            colorView.backgroundColor = colorWithHexString("#" + profile.color!)
            
        } else {
            // no data was obtained
            print("error, not item received")
        }
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func callButton(sender: AnyObject) {
        callNumber(phonenumber!)
    }
    
    @IBAction func emailButton(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    
    func callNumber(phoneNumber:String) {
        
        let stringArray = phoneNumber.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let phoneDigits = stringArray.joinWithSeparator("")
        
        
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneDigits)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email!])
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {   
        let alert = UIAlertController(title: "Could Not Send Email", message:"Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    // Source for this function: http://stackoverflow.com/questions/32297775/convert-hex-colors-to-rgb-in-swift-and-count-elements
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

}


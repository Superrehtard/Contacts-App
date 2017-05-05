//
//  Contact.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/3/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit

class Contact : NSObject {
    
    var name : String?
    var company : String?
    var favorite : Bool?
    var smallImageURL : String?
    var largeImageURL : String?
    var email : String?
    var website : String?
    var birthday : Date?
    
    var phone : [String : String]?
    var address : ContactAddress?
    
    // this method is called for each property and we need to override this for some properties like birthday etc.. to assign more meaningful values.
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "address" {
            address = ContactAddress()
            address?.setValuesForKeys(value as! [String: AnyObject])
        }
        else if key == "birthdate" {
            let secondsSinceBirth = Int(value as! String)! < 0 ? Int(value as! String)! : Int(value as! String)! * -1
            
            birthday = Date(timeIntervalSinceNow: TimeInterval(secondsSinceBirth))
        }
        else if key == "favorite" {
            favorite = Bool((value as? Bool)!)
        }
        else {
            super.setValue(value, forKey: key)
        }
    }
}



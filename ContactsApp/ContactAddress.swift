//
//  ContactAddress.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/3/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit
import MapKit

class ContactAddress : NSObject {
    
    var street:String?
    var city: String?
    var state : String?
    var country : String?
    var zip : String?
    
    // Making the latitude and longitude NSNumber makes it key-value coding compliant for when we try to set the values of address from a dictionary.
    var latitude : NSNumber?
    var longitude : NSNumber?
    
    // Just a method for debugging.
    func FullAddress() -> String {
        return "\(String(describing: self.street!)) \(String(describing: self.city!)) \(String(describing: self.state!)) \(String(describing: self.country!)) \(String(describing: self.zip!))"
    }
}

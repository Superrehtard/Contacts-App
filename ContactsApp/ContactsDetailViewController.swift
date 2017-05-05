//
//  ContactsDetailViewController.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/3/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class ContactsDetailViewController: UIViewController {
    
    // Outlets for all views on the Details ViewController
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var phone1Label: UILabel!
    @IBOutlet weak var phone2Label: UILabel!
    @IBOutlet weak var phone3Label: UILabel!
    @IBOutlet weak var contactAddressLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneType1: UILabel!
    @IBOutlet weak var phoneType2: UILabel!
    @IBOutlet weak var phoneType3: UILabel!
    
    // Stored property to get contact information.
    var contactDetail : Contact!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the navigation bar.
        self.navigationItem.title = "Contact Details"
        setUpNavBarButtons()

        self.largeImageView.downloadedFrom(link: contactDetail.largeImageURL!)
        self.largeImageView.clipsToBounds = true
        
        // Making the Image round to make it preeeteh.
        self.largeImageView.layer.cornerRadius = 75
        self.largeImageView.layer.masksToBounds = true
        
        self.nameLabel.text = contactDetail.name
        self.companyNameLabel.text = contactDetail.company
        
        // using postal address to format the address.
        self.contactAddressLabel.text = localizedStringForContactAddress(contactAddress: contactDetail.address!)
        
        self.birthDayLabel.text = contactDetail.birthday?.prettyDate()
        
        self.emailLabel.text = contactDetail.email
        
        self.websiteLabel.text = contactDetail.website
        
        // ToDo ## Need to handle this more elegantly.
        
        if contactDetail.phone?["work"] != nil && contactDetail.phone?["work"] != "" {
            self.phone1Label.text = contactDetail.phone?["work"]
        } else {
            self.phone1Label.isHidden = true
            self.phoneType1.isHidden = true
        }
        
        if ((contactDetail.phone?["home"]) != nil) && contactDetail.phone?["home"] != "" {
            self.phone2Label.text = contactDetail.phone?["home"]
        } else {
            self.phone2Label.isHidden = true
            self.phoneType2.isHidden = true
        }
        
        if ((contactDetail.phone?["mobile"]) != nil) && contactDetail.phone?["mobile"] != "" {
            self.phone3Label.text = contactDetail.phone?["mobile"]
        } else {
            self.phone3Label.isHidden = true
            self.phoneType3.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userLocationVC = segue.destination as? UserLocationViewController
        
        userLocationVC?.contact = contactDetail
    }

}

extension ContactsDetailViewController {
    
    // Setting the favorite and edit button on the navigation bar.
    func setUpNavBarButtons() {
        
        // getting image based on the favorite property of the contact.
        let favoriteImage = contactDetail.favorite! ? UIImage(named: "Star Filled")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "Star")?.withRenderingMode(.alwaysOriginal)
        
        let favoriteButton = UIButton.init(type: .custom)
        
        favoriteButton.setImage(favoriteImage, for: UIControlState.normal)
        favoriteButton.addTarget(self, action:#selector(handleFavorite), for: UIControlEvents.touchUpInside)
        favoriteButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        let favoriteBarButtonItem = UIBarButtonItem.init(customView: favoriteButton)
        
        // Renders image with original colors.
        let editImage = UIImage(named: "Edit")?.withRenderingMode(.alwaysOriginal)
        
        let editButton = UIButton.init(type: .custom)
        
        editButton.setImage(editImage, for: .normal)
        editButton.addTarget(self, action: #selector(editContact), for: .touchUpInside)
        editButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        let editBarButtonItem = UIBarButtonItem.init(customView: editButton)
        
        self.navigationItem.rightBarButtonItems = [editBarButtonItem, favoriteBarButtonItem]
    }
    
    func handleFavorite() {
        
        // Favorite or unFavorite a contact here.
        if contactDetail.favorite! {
            contactDetail.favorite = false
        } else {
            contactDetail.favorite = true
        }
        setUpNavBarButtons()
    }
    
    func editContact() {
        // Implement Contact editing here.
        displayMessage("Info", message: "Editing Contacts will be implement in the future versions, Thanks!")
    }
    
    // Convert to the newer CNPostalAddress
    func postalAddressFromContactAddress(_ contactAddress: ContactAddress) -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        
        address.street = contactAddress.street ?? ""
        address.state = contactAddress.state ?? ""
        address.city = contactAddress.city ?? ""
        address.country = contactAddress.country ?? ""
        address.postalCode = contactAddress.zip ?? ""
        
        return address
    }
    
    // Create a localized address string from the contact address.
    func localizedStringForContactAddress(contactAddress: ContactAddress) -> String {
        return CNPostalAddressFormatter.string(from: postalAddressFromContactAddress(contactAddress), style: .mailingAddress)
    }
    
    // Method to display an alert message.
    func displayMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cool", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

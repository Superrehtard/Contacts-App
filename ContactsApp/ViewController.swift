//
//  ViewController.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/3/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var contacts : [Contact]?
    var selectedContact : Int?
    
    // Creating a dictionary and an array for indexing the contacts list.
    var contactsDictionary = [String: [Contact]]()
    var contactSectionTitle = [String]()
    
    // Creating a A-Z array just for indexing.
    var fullIndexer = [String]()

    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullIndexer = generateAtoZArray()
        makeRequest()
    }
    
    func makeRequest() {
        
        // Set up the URL request
        let contactsEndPoint: String = "https://s3.amazonaws.com/technical-challenge/Contacts_v2.json"
        guard let url = URL(string: contactsEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        //Setting up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config) // Or we could just use shared session.
        
        // implement completion handler
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: processContactsResults)
        
        task.resume()
    }
    
    //: This function is used to parse the json data from the url.
    func processContactsResults(data:Data?,response:URLResponse?,error:Error?)->Void {
        
        // Making sure we got no errors while making the request.
        guard error == nil else {
            print("error calling GET on technical-challenge/Contacts_v2.json")
            print(error!)
            return
        }
        
        // Making sure we got data
        guard let responseData = data else {
            print("Error: did not receive data")
            return
        }
        
        // parse the result as JSON
        do {
            guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [NSDictionary] else {
                print("error trying to convert data to JSON")
                return
            }
            
            self.contacts = [Contact]()
            
            for dictionary in jsonResult {
                
                let contact = Contact()
                
                // Using the dictionary with the below function instead of setting each property of contact, making the code more readable.
                contact.setValuesForKeys(dictionary as! [String : AnyObject])
        
                self.contacts?.append(contact)
                
            }
            
            // sorting the contacts array so it conforms to the sorted sections, this makes it easy to send the contact details to the details page.
            self.contacts?.sort { $0.name! < $1.name! }
            
            // Once we get the contacts we need to generate the dictionary and titles array for indexing our contacts list.
            self.generateContactDict()
            
            //This line makes sure that the table is reloaded asynchronously after the current function is done executing.
            DispatchQueue.main.async(execute: {
                
                self.contactsTableView.reloadData()
            })
            
        } catch  {
            print("error trying to convert data to JSON")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Getting the destination control and sending data from current controller.
        let contactsDetailVC = segue.destination as? ContactsDetailViewController
        
        contactsDetailVC?.contactDetail = self.contacts?[(selectedContact)!]
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactSectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionKey = self.contactSectionTitle[section]
        
        if let sectionValues = self.contactsDictionary[sectionKey] {
            return sectionValues.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactCell
        
        let sectionKey = self.contactSectionTitle[indexPath.section]
        
        if let sectionValue = self.contactsDictionary[sectionKey] {
            cell?.contactNameLabel?.text = sectionValue[indexPath.row].name
            cell?.contactPhoneLabel?.text = sectionValue[indexPath.row].phone?["home"]
            cell?.contactPhoneLabel.textColor = UIColor.lightGray
            
            cell?.contactThumbnailImage?.downloadedFrom(link: (sectionValue[indexPath.row].smallImageURL)!)
            cell?.contactThumbnailImage?.clipsToBounds = true
            
            // Making the thumbnail image rounded.
            cell?.contactThumbnailImage?.layer.cornerRadius = 24
            cell?.contactThumbnailImage?.layer.masksToBounds = true
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactSectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Storing the selected row to use it during segue.
        
        self.selectedContact = getIndexFromSectionandRow(indexPath.row, section: indexPath.section)
        
        // Deselecting the row so as to remove highlighting of this row after you navigate back to contacts page.
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.fullIndexer
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let sectionIndex = self.contactSectionTitle.index(of: title) {
            return sectionIndex
        }
        
        return -1
    }
}

extension ViewController {
    
    // Generates both contacts dictionary and section titles used for indexing.
    func generateContactDict() {
        for contact in self.contacts! {
            
            let key = "\(contact.name![contact.name!.startIndex])".uppercased()
            
            if self.contactsDictionary[key] != nil {
                self.contactsDictionary[key]?.append(contact)
            } else {
                self.contactsDictionary[key] = [contact]
            }
        }
        
        self.contactSectionTitle = [String](self.contactsDictionary.keys)
        self.contactSectionTitle.sort()
    }
    
    // Method to get the index of the contact from row and section numbers.
    func getIndexFromSectionandRow(_ row: Int, section: Int) -> Int{
        
        var index = 0
        
        for i in 0..<section {
            
            let sectionKey = self.contactSectionTitle[i]
            
            if let sectionValues = self.contactsDictionary[sectionKey] {
                index += sectionValues.count
            }
        }
        
        return index + row
    }
    
    // Method to programmatically generate A-Z array using unicodeScalars.
    func generateAtoZArray() -> [String] {
        
        return (65..<(65+26)).map(UnicodeScalar.init).map({ String($0) })
    }
}


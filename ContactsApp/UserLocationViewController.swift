//
//  UserLocationViewController.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/5/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController {
    
    var contact:Contact!
    var location:CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Address"
        setUpNavBarButtons()
        
        // Placing an annotation pin at the contact's address.
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        location = CLLocationCoordinate2DMake(CLLocationDegrees(contact.address!.latitude!), CLLocationDegrees(contact.address!.longitude!))
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        // Creating the annotation here.
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = contact.name
        annotation.subtitle = contact.email
        
        // Add the annotation to the mapview.
        mapView.addAnnotation(annotation)
    }
    
}

extension UserLocationViewController {
    
    // Setting up navbar buttons similar to the contact details view.
    func setUpNavBarButtons() {
        
        let directionsImage = UIImage(named: "Directions")?.withRenderingMode(.alwaysOriginal)
        
        let directionsButton = UIButton.init(type: .custom)
        
        directionsButton.setImage(directionsImage, for: UIControlState.normal)
        directionsButton.addTarget(self, action:#selector(showNavigation), for: UIControlEvents.touchUpInside)
        directionsButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        let directionsBarButtonItem = UIBarButtonItem.init(customView: directionsButton)
        
        self.navigationItem.rightBarButtonItems = [directionsBarButtonItem]
    }
    
    // This methods handles the navigation once the user clicks on the button in navigation bar.
    func showNavigation() {
        
        let regionDistance:CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(location, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(contact.name!)'s Address"
        mapItem.openInMaps(launchOptions: options)
    }
}

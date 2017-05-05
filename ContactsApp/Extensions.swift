//
//  Extensions.swift
//  ContactsApp
//
//  Created by Pruthvi Parne on 5/3/17.
//  Copyright © 2017 Pruthvi Parne. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        contentMode = mode
        
        // Setting the image to nil to avoid loading incorrect image or image flicker when the table view cells are reused.
        // We could use default image here for slower internet connections.
        image = nil
        
        // Checking if the cache contains this image and if so then using that.
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            
            self.image = imageFromCache
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else {
                    
                    // During slow connection, the application waits for too long to load this image.
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "DefaultImage")
                    }
                    
                    return
            }
            
            DispatchQueue.main.async() { () -> Void in
                
                // Caching the images to with url string as the key, to reduce network load on the user.
                let imageToCache = UIImage(data: data)
                
                imageCache.setObject(imageToCache!, forKey: url.absoluteString as AnyObject)
                
                self.image = imageToCache
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

// Extending the bool behaivor to also take integers.
extension Bool {
    init<T : Integer>(_ integer: T){
        self.init(integer != 0)
    }
}

extension Date {
    
    // Method to get the pretty date for the birthdays.
    func prettyDate() -> String {
        
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        return formatter.string(from: self)
    }
    
}

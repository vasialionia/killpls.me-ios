//
//  DataLoader.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class DataLoader: NSObject {
    
    typealias DataLoaderCompletion = (items: [[String: AnyObject]]) -> Void
    
    func loadData(url url: NSURL, completionBlock: DataLoaderCompletion?) {
        
        NetworkActivityIndicator.sharedIndicator.increase()
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithURL(url) { (data, response, error) in

            if completionBlock != nil {
                if (response as? NSHTTPURLResponse)?.statusCode == 200 {
            
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                        completionBlock!(items: json as! [[String: AnyObject]])
                    }
                    catch {
                        completionBlock!(items: [])
                    }
                }
                else {
                    completionBlock!(items: [])
                }
            }
            
            NetworkActivityIndicator.sharedIndicator.decrease()
        }
        task.resume()
    }
}

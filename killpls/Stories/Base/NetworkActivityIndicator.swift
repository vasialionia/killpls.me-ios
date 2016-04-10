//
//  NetworkActivityIndicator.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class NetworkActivityIndicator: NSObject {

    static let sharedIndicator = NetworkActivityIndicator()
    private var usersCount = 0 {
        didSet {
            assert(usersCount >= 0)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = usersCount > 0
        }
    }
    
    func increase() {
        usersCount++;
    }
    
    func decrease() {
        usersCount--;
    }
}

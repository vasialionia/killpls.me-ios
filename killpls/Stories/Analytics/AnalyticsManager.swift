//
//  AnalyticsManager.swift
//  killpls
//
//  Created by drif on 4/13/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import Foundation

class AnalyticsManager: NSObject {

    static let sharedManager = AnalyticsManager()
    
    private let tracker: GAITracker
    
    override init() {
        
        GAI.sharedInstance().dispatchInterval = 3
        GAI.sharedInstance().trackUncaughtExceptions = true
        
        tracker = GAI.sharedInstance().trackerWithTrackingId("tracking_id")
    }
    
    func trackView(name name: String) {
        tracker.set(kGAIScreenName, value: name)
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject])
    }
}

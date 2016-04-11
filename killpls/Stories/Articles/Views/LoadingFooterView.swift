//
//  LoadingFooterView.swift
//  killpls
//
//  Created by drif on 4/11/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

@objc(LoadingFooterView) class LoadingFooterView: UIView {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    class func view() -> LoadingFooterView {
        return NSBundle.mainBundle().loadNibNamed(NSStringFromClass(LoadingFooterView.self), owner: self, options: nil).first as! LoadingFooterView
    }
}

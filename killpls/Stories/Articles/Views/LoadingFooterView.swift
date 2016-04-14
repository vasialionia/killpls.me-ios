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
    @IBOutlet weak var moreButton: ClosureButton!
    
    class func view() -> LoadingFooterView {
        return NSBundle.mainBundle().loadNibNamed(NSStringFromClass(LoadingFooterView.self), owner: self, options: nil).first as! LoadingFooterView
    }
    
    override func layoutSubviews() {
        frame.size = CGSize(width: frame.size.width, height: 75)
        super.layoutSubviews()
    }
}

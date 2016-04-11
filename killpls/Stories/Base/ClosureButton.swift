//
//  ClosureButton.swift
//  killpls
//
//  Created by drif on 4/10/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class ClosureButton: UIButton {
    
    typealias ClosureButtonEvent = (button: ClosureButton) -> Void
    
    var onTap: ClosureButtonEvent?
    
    var title: String? {
        get {
            return titleForState(.Normal)
        }
        set {
            setTitle(newValue, forState: .Normal)
        }
    }
    
    func onTap(button: ClosureButton) {
        onTap?(button: self)
    }
    
    class func button(title title: String, onTap: ClosureButtonEvent?) -> ClosureButton {
        
        let button = ClosureButton(type: .System)
        
        button.onTap = onTap
        button.title = title
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        button.addTarget(button, action: "onTap:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: "onTap:", forControlEvents: .TouchUpInside)
    }
}

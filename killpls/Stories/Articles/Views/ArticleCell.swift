//
//  ArticleCell.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

@objc(ArticleCell) class ArticleCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: ClosureButton!
    @IBOutlet weak var dislikeButton: ClosureButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet private weak var contentLabelWrapper: UIView!
    @IBOutlet private weak var tagsWrapper: UIView!
    
    var tagsButtons = [ClosureButton]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLabelWrapper.layer.shadowColor = UIColor.blackColor().CGColor
        contentLabelWrapper.layer.shadowOpacity = 0.3
        contentLabelWrapper.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentLabelWrapper.layer.shadowRadius = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentLabelWrapper.layer.shadowPath = UIBezierPath(rect: contentLabelWrapper.bounds).CGPath
    }
    
    private func tagButton(tag tag: String) -> ClosureButton {
        
        let button = ClosureButton.button(title: tag, onTap: nil)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(tag, forState: .Normal)
        
        return button
    }
    
    func setTags(tags tags: [String]) {
        
        for view in tagsWrapper.subviews {
            view.removeFromSuperview()
        }
        
        var lastButton: UIButton!
        tagsButtons.removeAll()
        
        for tag in tags {
            
            let button = tagButton(tag: tag)
            
            tagsWrapper.addSubview(button)
            tagsWrapper.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button]))
            
            if lastButton != nil {
                tagsWrapper.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button]-[lastButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button, "lastButton": lastButton]))
            }
            else {
                tagsWrapper.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button]))
            }
            
            lastButton = button
            tagsButtons.append(button)
        }
        
        tagsWrapper.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[lastButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["lastButton": lastButton]))
    }
    
    class func height(content content: String, width: CGFloat) -> CGFloat {
        return (content as NSString).boundingRectWithSize(CGSize(width: width - 20, height: CGFloat(Int.max)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13)!], context: nil).size.height + CGFloat(64)
    }
}

//
//  SideViewController.swift
//  killpls
//
//  Created by drif on 4/10/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

@objc(SideViewController) class SideViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tutorialImageView: UIImageView!
    
    private let mainController: UIViewController
    private let sideController: UIViewController
    
    let isTutorialShownKey = "SideViewController.isTutorialShown"
    private var isTutorialShown: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(isTutorialShownKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: isTutorialShownKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private var mainView: UIView {
        return mainController.view
    }
    
    private var sideView: UIView {
        return sideController.view
    }
    
    func onRightSwipe(recognizer: UISwipeGestureRecognizer) {
        setMainViewActive(active: false)
    }
    
    func onLeftSwipe(recognizer: UISwipeGestureRecognizer) {
        setMainViewActive(active: true)
    }
    
    func setMainViewActive(active active: Bool, animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.2 : 0, delay: 0, options: .CurveEaseOut, animations: { [weak mainView, weak sideView, weak contentView] in
            
            mainView?.transform = active ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.95, 0.95)
            mainView?.userInteractionEnabled = active
            
            sideView?.transform = active ? CGAffineTransformMakeTranslation(-(contentView?.bounds.size.width ?? 0), 0) : CGAffineTransformIdentity
            
            }) { [weak tutorialImageView, weak self] (_) in
                if animated && tutorialImageView != nil && !tutorialImageView!.hidden {
                    if active {
                        tutorialImageView!.hidden = true
                        self?.isTutorialShown = true
                    }
                    else {
                        tutorialImageView!.image = UIImage(named: "left")
                    }
                }
        }
    }
    
    required init(mainViewController: UIViewController, sideViewController: UIViewController) {
        
        mainController = mainViewController
        sideController = sideViewController
        
        super.init(nibName: nil, bundle: nil)
        
        addChildViewController(mainController)
        addChildViewController(sideController)
    }

    required init?(coder aDecoder: NSCoder) {
        
        mainController = UIViewController()
        sideController = UIViewController()
        
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        
        func initMainView() {
            
            mainView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(mainView)
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mainView": mainView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mainView": mainView]))
        }
        
        func initSideView() {

            sideView.layer.shadowColor = UIColor.blackColor().CGColor
            sideView.layer.shadowOpacity = 1
            sideView.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            sideView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(sideView)
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sideView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sideView": sideView]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sideView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sideView": sideView]))
            contentView.addConstraint(NSLayoutConstraint(item: sideView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 0.77, constant: 0))
        }
        
        func initRecongnizers() {
            
            let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "onRightSwipe:")
            rightSwipeRecognizer.direction = .Right
            
            let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "onLeftSwipe:")
            leftSwipeRecognizer.direction = .Left
            
            mainView.addGestureRecognizer(rightSwipeRecognizer)
            mainView.addGestureRecognizer(leftSwipeRecognizer)
            sideView.addGestureRecognizer(leftSwipeRecognizer)
            contentView.addGestureRecognizer(leftSwipeRecognizer)
        }

        contentView.backgroundColor = UIColor.blackColor()
        
        initMainView()
        initSideView()
        initRecongnizers()
        
        setMainViewActive(active: true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        
        sideView.layoutIfNeeded()
        
        sideView.layer.shadowPath = UIBezierPath(rect: sideView.bounds).CGPath
        sideView.layer.shadowRadius = contentView.bounds.size.width * 0.1
    }
    
    override func viewWillAppear(animated: Bool) {
        if !isTutorialShown {
            tutorialImageView.hidden = false
        }
    }
}

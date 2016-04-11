//
//  SideViewController.swift
//  killpls
//
//  Created by drif on 4/10/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {
    
    private let mainController: UIViewController
    private let sideController: UIViewController
    
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
    
    private func setMainViewActive(active active: Bool, animated: Bool = true) {
        UIView.animateWithDuration(animated ? 0.2 : 0, delay: 0, options: .CurveEaseOut, animations: { [weak mainView, weak sideView, weak view] in
            
            mainView?.transform = active ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.95, 0.95)
            mainView?.userInteractionEnabled = active
            
            sideView?.transform = active ? CGAffineTransformMakeTranslation(-(view?.bounds.size.width ?? 0), 0) : CGAffineTransformIdentity
            
        }, completion: nil)
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
            view.addSubview(mainView)
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mainView": mainView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mainView": mainView]))
        }
        
        func initSideView() {

            sideView.layer.shadowColor = UIColor.blackColor().CGColor
            sideView.layer.shadowOpacity = 1
            sideView.layer.shadowOffset = CGSize(width: 0, height: 0)
            sideView.layer.shadowRadius = 10
            
            sideView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(sideView)
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sideView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sideView": sideView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sideView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sideView": sideView]))
            view.addConstraint(NSLayoutConstraint(item: sideView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.75, constant: 0))
        }
        
        func initRecongnizers() {
            
            let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "onRightSwipe:")
            rightSwipeRecognizer.direction = .Right
            
            let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "onLeftSwipe:")
            leftSwipeRecognizer.direction = .Left
            
            mainView.addGestureRecognizer(rightSwipeRecognizer)
            mainView.addGestureRecognizer(leftSwipeRecognizer)
            sideView.addGestureRecognizer(leftSwipeRecognizer)
            view.addGestureRecognizer(leftSwipeRecognizer)
        }

        view.backgroundColor = UIColor.blackColor()
        
        initMainView()
        initSideView()
        initRecongnizers()
        
        setMainViewActive(active: true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        sideView.layer.shadowPath = UIBezierPath(rect: sideView.bounds).CGPath
        sideView.layer.shadowRadius = view.bounds.size.width * 0.1
    }
}

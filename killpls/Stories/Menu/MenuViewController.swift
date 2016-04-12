//
//  MenuViewController.swift
//  killpls
//
//  Created by drif on 4/12/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit
import MessageUI

@objc(MenuViewController) class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    enum Sections: Int {
        case New
        case Tags
        case Contacts
        case SourceCode
        case Count
    }
    
    enum ContactsRows: Int {
        case Connect
        case ReportBug
        case Count
    }
    
    enum SourceCodeRows: Int {
        case IOS
        case Backend
        case Count
    }
    
    private let tags = [
        "внешность",
        "деньги",
        "друзья",
        "здоровье",
        "отношения",
        "работа",
        "разное",
        "родители",
        "секс",
        "семья",
        "техника",
        "учёба"
    ]
    
    typealias MenuViewControllerTagTap = (tag: String?) -> Void
    
    var onTagTap: MenuViewControllerTagTap?
    
    @IBOutlet weak var statusBarBlurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        }
    }
    
    override func viewDidLoad() {
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        statusBarBlurViewHeightConstraint.constant = statusBarHeight
        tableView.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Sections.Count.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCase = Sections(rawValue: section)!
        
        switch sectionCase {
        case .New:
            return 1
        case .Tags:
            return tags.count
        case .Contacts:
            return ContactsRows.Count.rawValue
        case .SourceCode:
            return SourceCodeRows.Count.rawValue
        case .Count:
            assert(false)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self))!
        let sectionCase = Sections(rawValue: indexPath.section)!
        
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        switch sectionCase {
        case .New:
            cell.textLabel!.text = "новые"
            
        case .Tags:
            cell.textLabel!.text = tags[indexPath.row]
            
        case .Contacts:
            let rowCase = ContactsRows(rawValue: indexPath.row)!
            switch(rowCase) {
            case .Connect:
                cell.textLabel!.text = "связаться с разработчиком"
                
            case .ReportBug:
                cell.textLabel!.text = "сообщить о проблеме"
                
            case .Count:
                assert(false)
            }
            
        case .SourceCode:
            let rowCase = SourceCodeRows(rawValue: indexPath.row)!
            switch(rowCase) {
            case .IOS:
                cell.textLabel!.text = "исходный код iOS приложения"
                
            case .Backend:
                cell.textLabel!.text = "исходный код web-сервера"
                
            case .Count:
                assert(false)
            }
            
        case .Count:
            assert(false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionCase = Sections(rawValue: indexPath.section)!
        
        switch sectionCase {
        case .New:
            onTagTap?(tag: nil)
            
        case .Tags:
            onTagTap?(tag: tags[indexPath.row])
            
        case .SourceCode:
            let rowCase = SourceCodeRows(rawValue: indexPath.row)!
            switch(rowCase) {
            case .IOS:
                UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/vasialionia/killpls.me-ios")!)
                
            case .Backend:
                UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/vasialionia/killpls.me-api")!)
                
            case .Count:
                assert(false)
            }
            
        case .Contacts:
            var topic: String!
            
            let rowCase = ContactsRows(rawValue: indexPath.row)!
            switch(rowCase) {
            case .Connect:
                topic = "Support"
                
            case .ReportBug:
                topic = "ReportBug"
                
            case .Count:
                assert(false)
            }
            
            let mailComposer = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("[killple.me][\(topic)]")
            mailComposer.setToRecipients(["leo.kuharev@gmail.com", "blrdrif@gmail.com"])
            
            presentViewController(mailComposer, animated: true, completion: nil)
            
        case .Count:
            assert(false)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

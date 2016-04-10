//
//  ArticlesViewController.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

@objc(ArticlesViewController) class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let articlesProvider = ArticlesProvider()
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var statusBarBlurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "onRefreshControl:", forControlEvents: UIControlEvents.ValueChanged)
            tableView.addSubview(refreshControl)
            
            tableView.registerNib(UINib(nibName: NSStringFromClass(ArticleCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(ArticleCell.self))
            
            tableView.separatorColor = UIColor.clearColor()
        }
    }
    
    private func startLoading() {
        
        if articlesProvider.isLoading {
            return
        }
        
        refreshControl.beginRefreshing()
        articlesProvider.loadArticles { [weak tableView, refreshControl] in
            tableView?.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    func onRefreshControl(refreshControl: UIRefreshControl) {
        startLoading()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        statusBarBlurViewHeightConstraint.constant = statusBarHeight
        tableView.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        startLoading()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesProvider.articlesCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ArticleCell.self)) as! ArticleCell
        let article = articlesProvider.article(index: indexPath.row)
        
        cell.dateLabel.text = article.postedAt
        cell.idLabel.text = "#\(article.id)"
        cell.contentLabel.text = article.content
        cell.setTags(tags: article.tags)
        cell.likeButton.setTitle("+ \(article.likesCount) -", forState: UIControlState.Normal)
        
        cell.likeButton.onTap = { (_) in
            UIApplication.sharedApplication().openURL(article.url)
        }
        
        for button in cell.tagsButtons {
            button.onTap = { (button) in
                print("\(button.title)")
            }
        }
        
        return cell
    }
}

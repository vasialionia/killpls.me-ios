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
    
    private var bottomActivityIndicator: UIActivityIndicatorView! {
        return (tableView.tableFooterView as? LoadingFooterView)?.activityIndicatorView
    }
    
    var tag: String? {
        didSet {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: true)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * Int64(200)), dispatch_get_main_queue()) { [weak self, tag] in
                self?.articlesProvider.tag = tag
                self?.startLoading()
            }
            
            tagButtonCover.hidden = (tag == nil)
            tagButton.title = "\(tag ?? "") ╳"
        }
    }
    
    @IBOutlet private weak var tagButtonCover: UIVisualEffectView! {
        didSet {
            tagButtonCover.layer.masksToBounds = true
            tagButtonCover.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet private weak var tagButton: ClosureButton!
    @IBOutlet private weak var statusBarBlurViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "onRefreshControl:", forControlEvents: .ValueChanged)
            tableView.addSubview(refreshControl)
            
            tableView.registerNib(UINib(nibName: NSStringFromClass(ArticleCell.self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(ArticleCell.self))
            
            tableView.separatorColor = UIColor.clearColor()
            tableView.tableFooterView = LoadingFooterView.view()
        }
    }
    
    @IBAction private func onTagButtonTap(sender: ClosureButton) {
        tag = nil
    }
    
    private func startLoading(loadMore loadMore: Bool = false) {
        
        if articlesProvider.isLoading {
            return
        }
        
        refreshControl.beginRefreshing()
        
        if articlesProvider.articlesCount > 0 {
            bottomActivityIndicator.startAnimating()
        }
        
        articlesProvider.loadArticles(loadMore: loadMore) { [weak refreshControl, bottomActivityIndicator] (error) in
            refreshControl?.endRefreshing()
            bottomActivityIndicator?.stopAnimating()
            
            if error != nil {
                UIAlertView(title: "Ошибка", message: error!, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
            }
        }
    }
    
    func onRefreshControl(refreshControl: UIRefreshControl) {
        startLoading()
    }
    
    private func voteArticle(article article: Article, like: Bool, cell: ArticleCell?) {
        
        cell?.likeButton.hidden = true
        cell?.dislikeButton.hidden = true
        
        self.articlesProvider.voteArticle(article: article, like: true) { (error) in
            
            if error != nil {
                
                cell?.likeButton.hidden = false
                cell?.dislikeButton.hidden = false
                UIAlertView(title: "Ошибка", message: error!, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
            }
        }
    }
    
    override func viewDidLoad() {
        
        articlesProvider.onUpdateBegin = { [weak self] in
            self?.tableView.beginUpdates()
        }
        articlesProvider.onUpdateEnd = { [weak self] in
            self?.tableView.endUpdates()
        }
        articlesProvider.onUpdate = { [weak self] (type, indexes) in
            if indexes.count == 0 {
                return
            }

            var indexPaths = [NSIndexPath]()
            for index in indexes {
                indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
            }
            
            switch type {
            case .Update:
                self?.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            case .Delete:
                self?.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            case .Insert:
                self?.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
        }
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        statusBarBlurViewHeightConstraint.constant = statusBarHeight
        tableView.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: -tableView.tableFooterView!.bounds.size.height, right: 0)
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
        cell.likesLabel.text = "\(article.likesCount)"
        
        cell.likeButton.hidden = article.isVoted
        cell.likeButton.onTap = { [weak self, weak cell] (_) in
            self?.voteArticle(article: article, like: true, cell: cell)
        }
        
        cell.dislikeButton.hidden = article.isVoted
        cell.dislikeButton.onTap = { [weak self, weak cell] (_) in
            self?.voteArticle(article: article, like: false, cell: cell)
        }
        
        for button in cell.tagsButtons {
            button.onTap = { [weak self] (button) in
                self?.tag = button.title
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == articlesProvider.articlesCount - 1 {
            startLoading(loadMore: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let article = articlesProvider.article(index: indexPath.row)
        return ArticleCell.height(content: article.content, width: tableView.bounds.size.width)
    }
}

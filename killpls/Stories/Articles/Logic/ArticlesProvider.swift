//
//  ArticlesProvider.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class ArticlesProvider: NSObject {
    
    typealias ArticlesProviderCompletion = (error: String?) -> Void
    typealias ArticlesProviderEvent = () -> Void
    typealias ArticlesProviderUpdate = (type: UpdateType, indexes: [Int]) -> Void
    
    enum UpdateType {
        case Insert
        case Delete
        case Update
    }
    
    private let dataLoader = DataLoader()
    private var articles = [Article]()
    private var offset = 0
    private(set) var isLoading = false
    private let baseUrl = "http://0.0.0.0:5000/api/"
    
    var onUpdateBegin: ArticlesProviderEvent?
    var onUpdateEnd: ArticlesProviderEvent?
    var onUpdate: ArticlesProviderUpdate?
    
    var tag: String?
    
    private let votedArticlesIdsKey = "ArticlesProvider.loadedArticlesIds"
    private var votedArticlesIds: [Int] {
        return (NSUserDefaults.standardUserDefaults().objectForKey(votedArticlesIdsKey) ?? []) as! [Int]
    }
    
    private func addVotedArticleId(id id: Int) {
        
        var articlesIds = votedArticlesIds
        articlesIds.append(id)
        
        NSUserDefaults.standardUserDefaults().setObject(articlesIds, forKey: votedArticlesIdsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func mergeArticles(var loadedArticles loadedArticles: [Article], deleteOld: Bool) {
        
        func mergeDelete() {
            var deletedIndexes = [Int]()
            var updatedIndexes = [Int]()
            var filteredArticles = [Article]()
            
            for (i, article) in articles.enumerate() {
                if loadedArticles.contains(article) {
                    filteredArticles.append(article)
                    loadedArticles.removeAtIndex(loadedArticles.indexOf(article)!)
                    updatedIndexes.append(i)
                }
                else {
                    deletedIndexes.append(i)
                }
            }
            
            articles = filteredArticles
            
            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                self?.onUpdate?(type: .Delete, indexes: deletedIndexes)
                self?.onUpdate?(type: .Update, indexes: updatedIndexes)
            }
        }
        
        func mergeInsert() {
            var insertedIndexes = [Int]()
            
            if articles.count > 0 {
                var oldIndex = 0
                var newIndex = 0
                
                while newIndex < loadedArticles.count {
                    if articles.contains(loadedArticles[newIndex]) {
                        newIndex++
                        continue
                    }
                    
                    if loadedArticles[newIndex].id < articles.last!.id {
                        insertedIndexes.append(articles.count)
                        articles.append(loadedArticles[newIndex])
                        newIndex++
                    }
                    else {
                        if loadedArticles[newIndex].id > articles[oldIndex].id {
                            articles.insert(loadedArticles[newIndex], atIndex: oldIndex)
                            insertedIndexes.append(oldIndex)
                            newIndex++
                        }
                        oldIndex++
                    }
                }
            }
            else {
                articles = loadedArticles
                insertedIndexes = Array(0..<loadedArticles.count)
            }
            
            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                self?.onUpdate?(type: .Insert, indexes: insertedIndexes)
            }
        }
        
        if onUpdate != nil {
            
            assert(!NSThread.isMainThread())
            
            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                self?.onUpdateBegin?()
            }
            
            if deleteOld {
                mergeDelete()
            }
            
            mergeInsert()
            
            dispatch_sync(dispatch_get_main_queue()) { [weak self] in
                self?.onUpdateEnd?()
            }
        }
    }
    
    var articlesCount: Int {
        return articles.count
    }
    
    func article(index index: Int) -> Article {
        return articles[index]
    }
    
    func loadArticles(loadMore loadMore: Bool, completion: ArticlesProviderCompletion?) {
        
        func articlesUrl() -> NSURL {
            
            var urlString = "\(baseUrl)article"
            
            if tag != nil {
                urlString += "/tag/\(tag!)"
            }
            
            urlString += "?offset=\(offset)&limit=10"
            urlString = (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            return NSURL(string: urlString)!
        }
        
        assert(!isLoading)
        
        isLoading = true
        
        if !loadMore {
            offset = 0
        }
        
        dataLoader.loadData(method: "GET", url: articlesUrl()) { [weak self] (items, error) in
            
            if self != nil {
                
                var loadedArticles = [Article]()
                let voted = self!.votedArticlesIds
                for item in items {
                    let article = Article(json: item)
                    article.isVoted = (voted.contains(article.id))
                    loadedArticles.append(article)
                }
                
                self!.mergeArticles(loadedArticles: loadedArticles, deleteOld: !loadMore)
                self!.offset += items.count
                self!.isLoading = false
            }
            
            if completion != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(error: error)
                }
            }
        }
    }
    
    func voteArticle(article article: Article, like: Bool, completion: ArticlesProviderCompletion?) {
        
        func voteUrl() -> NSURL {
            let urlString = "\(baseUrl)article/\(article.id)/vote/\(like ? "yes" : "no")"
            return NSURL(string: urlString)!
        }
        
        dataLoader.loadData(method: "POST", url: voteUrl()) { [weak self] (_, error) -> Void in
            
            if error == nil {
                article.isVoted = true
                self?.addVotedArticleId(id: article.id)
            }
            
            if completion != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(error: error)
                }
            }
        }
    }
}

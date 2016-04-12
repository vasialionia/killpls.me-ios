//
//  ArticlesProvider.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class ArticlesProvider: NSObject {
    
    typealias ArticlesProviderCompletion = () -> Void
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
    
    var onUpdateBegin: ArticlesProviderEvent?
    var onUpdateEnd: ArticlesProviderEvent?
    var onUpdate: ArticlesProviderUpdate?
    
    var tag: String?
    
    private var url: NSURL {
        
        var urlString = "http://0.0.0.0:5000/api/article"
        
        if tag != nil {
            urlString += "/tag/\(tag!)"
        }
        
        urlString += "?offset=\(offset)&limit=10"
        urlString = (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        return NSURL(string: urlString)!
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
        
        assert(!isLoading)
        
        isLoading = true
        
        if !loadMore {
            offset = 0
        }
        
        dataLoader.loadData(url: url) { [weak self] (items) in
            
            if self != nil {
                
                var loadedArticles = [Article]()
                for item in items {
                    loadedArticles.append(Article(json: item))
                }
                
                self?.mergeArticles(loadedArticles: loadedArticles, deleteOld: !loadMore)
                self?.offset += items.count
                self?.isLoading = false
            }
            
            if completion != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?()
                }
            }
        }
    }
}

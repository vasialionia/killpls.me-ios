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
    
    private let dataLoader = DataLoader()
    private var articles = [Article]()
    private(set) var isLoading = false
    
    var articlesCount: Int {
        return articles.count
    }
    
    func article(index index: Int) -> Article {
        return articles[index]
    }
    
    func loadArticles(completion completion: ArticlesProviderCompletion?) {
        
        isLoading = true
        
        dataLoader.loadData(url: NSURL(string: "http://0.0.0.0:5000/api/article")!) { [weak self] (items) in
            
            if self != nil {
                
                var loadedArticles = [Article]()
                for item in items {
                    loadedArticles.append(Article(json: item))
                }
                
                self?.articles = loadedArticles
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

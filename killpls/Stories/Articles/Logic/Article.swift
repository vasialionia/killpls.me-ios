//
//  Article.swift
//  killpls
//
//  Created by drif on 4/9/16.
//  Copyright © 2016 vasialionia. All rights reserved.
//

import UIKit

class Article: NSObject {

    let id: Int
    let content: String
    let postedAt: String
    let tags: [String]
    let likesCount: Int
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let article = object as? Article {
            return article.id == id
        }
        else {
            return false
        }
    }
    
    var url: NSURL {
        return NSURL(string: "http://killpls.me/story/\(id)")!
    }

    init(json: [String: AnyObject]) {
        id = json["id"] as! Int
        content = json["content"] as! String
        postedAt = json["posted_at"] as! String
        tags = (json["tags"] as! String).componentsSeparatedByString(",")
        likesCount = json["likes_count"] as! Int
    }
}

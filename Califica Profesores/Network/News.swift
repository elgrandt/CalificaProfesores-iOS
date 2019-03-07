//
//  News.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 05/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import Firebase

class NewsItem {
    var author : String?
    var content : String?
    var timestamp : Int64?
    var title : String?
}

protocol NewsNetwork {
    func arrivedNews(news : [NewsItem])
}

extension NewsNetwork {
    func startGettingNews() {
        let ref = Database.database().reference()
        ref.child("Novedades").queryOrdered(byChild: "timestamp").observe(.value, with: {(snapshot) in
            var news : [NewsItem] = []
            let dict = snapshot.value as! [String : NSDictionary]
            let values = dict.values.sorted(by: { (d1, d2) in
                return (d1["timestamp"] as! Int64) < (d2["timestamp"] as! Int64)
            })
            for new in values {
                let current = NewsItem()
                current.author = new["author"] as? String
                current.content = new["content"] as? String
                current.timestamp = new["timestamp"] as? Int64
                current.title = new["title"] as? String
                news.append(current)
            }
            self.arrivedNews(news: news)
        })
    }
}

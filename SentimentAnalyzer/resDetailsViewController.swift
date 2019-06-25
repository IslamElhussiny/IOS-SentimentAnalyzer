//
//  resDetailsViewController.swift
//  
//
//  Created by Islam Elsayed on 6/8/19.
//

import UIKit
import SwiftyJSON
class resDetailsViewController: UIViewController {
   
    @IBOutlet weak var firstRes: UILabel!
    @IBOutlet weak var secondRes: UILabel!
    @IBOutlet weak var thirdRes: UILabel!
    var dataRecieved : JSON? = nil // json recieved from first view controller
    var weight : JSON? = nil // part of json content
    var stats =  Dictionary<String, JSON>() // restaurant statistics json second content part
    var statsKeys = Array<Any>() // the keys to be printed as values individually
    var ranks : JSON? = nil // the rank of each restaurant , third json content part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.dataRecieved ?? 0)
        self.weight = self.dataRecieved?["Overall Weight"]
        print(weight ?? 0)
        self.stats = self.dataRecieved?["Statistics"].dictionary ?? ["":0]
        print(stats)
        self.statsKeys = Array((self.stats.keys))
        print(statsKeys)
        self.ranks = self.dataRecieved?["Ranking"]
        print(ranks?[0][0].stringValue as Any,ranks?[0][1].stringValue as Any)
        let first = ranks?[0][0].stringValue
        
        DispatchQueue.main.async {
            self.firstRes.text = first
        }
        
        print("json recieved")
    }
}
    


//if let ranks = ranks {
//for i in 0..<ranks.count{
//  print(ranks[i][0] as Any,ranks[i][1] as Any)
//self.arrOfLabels[i] = ranks[i][0].stringValue//}

/*
getAyatFromMostSimilarTopic(query: userQuerySearchBar.text!, completionHandler: {(success) -> Void in
    if success {
        self.performUIUpdatesOnMain {
            self.hideActivityIndicator()
            self.adjustMenuAndTable(isHidden: false)
            self.refreshContent()
        }
    } else {
        self.performUIUpdatesOnMain {
            self.hideActivityIndicator()
            self.showNoDataLabel()
        }
    }
})*/

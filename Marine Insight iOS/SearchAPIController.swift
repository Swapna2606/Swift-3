//
//  SearchAPIController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 04/05/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import Foundation
class APIController {
    
    var delegate: APIControllerProtocol?
    
    init() {
    }
    
//    func searchItunesFor(searchTerm: String) {
//        
//        
//        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
//        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSString.CompareOptions.CaseInsensitiveSearch, range: nil)
//        
//        // Now escape anything else that isn't URL-friendly
//        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        let urlPath = "http://www.marineinsight.com/?s=\(escapedSearchTerm)&json=1&count=20"
//        let url = URL(string: urlPath)!
//        var request = URLRequest(url: url)
//        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
//        
//        
//        //println("Search iTunes API at URL \(url)")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
//            //   println("Task completed")
//            if(error != nil) {
//                // If there is an error in the web request, print it to the console
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//            
//            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
//            if(err != nil) {
//                // If there is an error parsing JSON, print it to the console
//                println("JSON Error \(err!.localizedDescription)")
//            }
//            let results: NSArray = jsonResult["posts"] as! NSArray
//            self.delegate?.didReceiveAPIResults(jsonResult)
//            //        dispatch_async(dispatch_get_main_queue(), {
//            //            self.tableData = results
//            //            self.searchTableView!.reloadData()
//            //        })
//        })
//        task.resume()
//        
//        // connection.start()
//    }
//}

func searchForTerm(searchTerm: String){
    
    let modifiedSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
    let escapedSearchTerm:String = modifiedSearchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    let urlPath = "http://www.marineinsight.com/?s=\(escapedSearchTerm)&json=1&count=20"
    print(urlPath)
    let url = URL(string: urlPath)!
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
        
        if error != nil{
            print(error as Any)
            return
        }
        
     //   self.articles = [Article]()
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
            if let articlesFromJson = json["posts"] as? [String : AnyObject]{
                self.delegate?.didReceiveAPIResults(results: articlesFromJson)
                
            }
  
            
        }
        catch let error{
            print(error)
        }
        
    }
    
    task.resume()
    
    
    }
}

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: [String: AnyObject])
}

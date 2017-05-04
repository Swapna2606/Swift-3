//
//  ViewController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 21/04/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var tableView: UITableView!
    var articles: [Article]? = []
    var source = "shipping-news"
    var refresher: UIRefreshControl!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(currentReachabilityStatus != .notReachable) {
        
        fetchArticles(fromSouce: source)
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(ViewController.fetchArticles), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        }
        
        else{
            print("Not Connected")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            self.showAlert(title: "No Internet Connection", message: "Please check your network connection and try again.")
        }
    }
    
    func fetchArticles(fromSouce provider: String){
    
        let urlRequest = URLRequest(url: URL(string:"http:www.marineinsight.com/api/get_recent_posts/?json=get_category_posts&slug=\(provider)&count=8")!)
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
        
            if error != nil{
            print(error as Any)
            return
            }
            
            self.articles = [Article]()
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articlesFromJson = json["posts"] as? [[String : AnyObject]]{
                    for articleFromJson in articlesFromJson{
                        let article = Article()
                        if let title = articleFromJson["title"] as? String,let content = articleFromJson["content"] as? String,let url = articleFromJson["url"] as? String,let thumbnailUrl = articleFromJson["thumbnail"] as? String, let author = articleFromJson["author"] as? [String : AnyObject], let mainImg = articleFromJson["thumbnail_images"] as? [String : AnyObject]{
                            
                                let authorName = author["name"] as? String
                                let mainImgUrlGet = mainImg["medium"] as? [String : AnyObject]
                                let mainImgUrl = mainImgUrlGet?["url"] as? String
                            
                                article.title = title
                                article.author = authorName
                                article.content = content
                                article.url = url
                                article.thumbnail = thumbnailUrl
                                article.topImgUrl = mainImgUrl
                            
                        }
                        self.articles?.append(article)
                    
                    }
                
                }
                DispatchQueue.main.async {
                    self.refresher.endRefreshing()
                   self.tableView.reloadData()
                }
            
            }
            catch let error{
            print(error)
            }
        
        }
       
        task.resume()
        
    
    }
    
    let menuManager = MenuManager()
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
       
            let cell = Bundle.main.loadNibNamed("FirstTableViewCell", owner: self, options: nil)?.first as! FirstTableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
            cell.postTitle.text = self.articles?[indexPath.item].title?.html2AttributedString?.string
            cell.imgView.downloadImage(from: (self.articles?[indexPath.item].topImgUrl!)!)
            return cell
        
        }
        
        else{
            let cell = Bundle.main.loadNibNamed("SecondTableViewCell", owner: self, options: nil)?.first as! SecondTableViewCell
            cell.postTitle.text = self.articles?[indexPath.item].title?.html2AttributedString?.string
            cell.imgView.downloadImage(from: (self.articles?[indexPath.item].thumbnail!)!)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
        return 200
        }
        else{
        
        return 110
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailViewController
        let contentToParse = self.articles?[indexPath.item].content
        let contentToDisplay = NSString(format: "%@%@%@", self, "<style type='text/css'>img {width: 300px; height: auto;} iframe {width: 300px; height: auto;}img.wp-image-42223{display:none;} .wp-caption-text{font-size:5px;}</style>", contentToParse! ) as String
        webVC.detailTitle = self.articles?[indexPath.item].title
        webVC.authorName = self.articles?[indexPath.item].author
        webVC.url = self.articles?[indexPath.item].url
        webVC.detailContent = contentToDisplay
        self.present(webVC, animated: true, completion: nil)
    }

}

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var unicodes: [UInt32] { return unicodeScalars.map{$0.value} }
}

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        DispatchQueue.main.async { [unowned self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

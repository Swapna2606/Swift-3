//
//  ViewController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 21/04/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet var bannerAd: GADBannerView!
    @IBOutlet var tableView: UITableView!
    var articles: [Article]? = []
    var source = "shipping-news"
    var refresher: UIRefreshControl!
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
  
     let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    func activityIndicator(_ title: String) {

        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()

        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 230, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 230, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()

        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        if(currentReachabilityStatus != .notReachable) {
//          //activityIndicator("Getting Things Onboard...")
//        let request = GADRequest()
//            request.testDevices = [kGADSimulatorID]
//            bannerAd.adUnitID = "ca-app-pub-3904893075452390/1951730882"
//            bannerAd.rootViewController = self
//            bannerAd.load(request)
//
//        fetchArticles(fromSouce: source)
//        refresher = UIRefreshControl()
//        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
//        refresher.addTarget(self, action: #selector(ViewController.fetchArticles), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refresher)
//        }
//
//        else{
//            print("Not Connected")
//            let noInternetVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
//            self.present(noInternetVC, animated: true, completion: nil)
//            print("something is wrong")
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(currentReachabilityStatus != .notReachable) {
            //activityIndicator("Getting Things Onboard...")
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerAd.adUnitID = "ca-app-pub-3904893075452390/1951730882"
            bannerAd.rootViewController = self
            bannerAd.load(request)
            
            fetchArticles(fromSouce: source)
            refresher = UIRefreshControl()
            refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
            refresher.addTarget(self, action: #selector(ViewController.fetchArticles), for: UIControlEvents.valueChanged)
            tableView.addSubview(refresher)
        }
            
        else{
            print("Not Connected")
            let noInternetVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noInternet") as! NoInternetViewController
            self.present(noInternetVC, animated: true, completion: nil)
            print("something is wrong")
        }
    }
    
    @objc func fetchArticles(fromSouce provider: String){
          activityIndicator("Getting Things Onboard...")
       let defaultThumbnailUrl = "http://www.marineinsight.com/wp-content/uploads/2017/01/MI-logo.png"
       let defaultMainImgUrl = "https://www.marineinsight.com/wp-content/uploads/2014/08/MI-transparent.png"
        
    
        let urlRequest = URLRequest(url: URL(string:"https://www.marineinsight.com/api/get_recent_posts/?json=get_category_posts&slug=\(provider)&count=8")!)
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
                        if let title = articleFromJson["title"] as? String{
                            article.title = title
                        }
                        if let content = articleFromJson["content"] as? String
                        {
                             article.content = content
                        }
                        if let url = articleFromJson["url"] as? String{
                             article.url = url
                        }
                        if let thumbnailUrl = articleFromJson["thumbnail"] as? String{
                            article.thumbnail = thumbnailUrl
                           // print("thumbs" + defaultThumbnailUrl)
                        }
                        else{
                            article.thumbnail = defaultThumbnailUrl
                           // print("thumbs default" + defaultThumbnailUrl)
                        }
            
                        if let author = articleFromJson["author"] as? [String : AnyObject]{
                        let authorName = author["name"] as? String
                            article.author = authorName
                        }
                        if let mainImg = articleFromJson["thumbnail_images"] as? [String : AnyObject]
                        {
                            if let mainImgUrlGet = mainImg["medium"] as? [String : AnyObject]{
                                if let mainImgUrl = mainImgUrlGet["url"] as? String{
                                    article.topImgUrl = mainImgUrl
                                   //print("MAIN" + mainImgUrl)
                                }
                                else{
                                    article.topImgUrl = defaultMainImgUrl

                                }
                            }
                            else{
                                article.topImgUrl = defaultMainImgUrl
                            }
                            
                        }
                        else{
                            article.topImgUrl = defaultMainImgUrl
                        }
                        
                        self.articles?.append(article)
                    
                    }
                
                }
                DispatchQueue.main.async {
                    self.effectView.removeFromSuperview()
                    self.refresher.endRefreshing()
                   self.tableView.reloadData()
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
    @IBAction func searchPressed(_ sender: Any) {
         let searchVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(searchVC, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
       
            let cell = Bundle.main.loadNibNamed("FirstTableViewCell", owner: self, options: nil)?.first as! FirstTableViewCell
            cell.postTitle.text = self.articles?[indexPath.item].title?.html2AttributedString?.string
             let imgUrl = self.articles?[indexPath.item].topImgUrl!
            cell.imgView.downloadImage(from: imgUrl!)
            return cell
        
        }
        
        else{
            let cell = Bundle.main.loadNibNamed("SecondTableViewCell", owner: self, options: nil)?.first as! SecondTableViewCell
            cell.postTitle.text = self.articles?[indexPath.item].title?.html2AttributedString?.string
            let imgUrl2 = self.articles?[indexPath.item].thumbnail!
            cell.imgView.downloadImage(from: imgUrl2!)
          
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
        let contentToDisplay = NSString(format: "%@%@%@", self, "<style type='text/css'>img {max-width:100%%;height:auto !important;width:auto !important;} iframe {width: 300px; height: auto;}img.wp-image-42223{display:none;} .wp-caption-text{font-size:5px;}</style>", contentToParse! ) as String
        webVC.detailTitle = self.articles?[indexPath.item].title?.html2AttributedString?.string
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
            
//            if error == nil {
//                if(UIImage(data: data!) != nil){
//                    self.image = UIImage(data: data!)!
//                } else {
//                    self.image = UIImage(named: "Logo")!
//                }
//            }
        }
        task.resume()
    }
}

//extension String {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentAttributeKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//    var unicodes: [UInt32] { return unicodeScalars.map{$0.value} }
//}

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
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

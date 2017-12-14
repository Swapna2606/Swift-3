//
//  SearchViewController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 06/06/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SearchViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    var articles: [Article]? = []
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchBarNew: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet var bannerAdSearch: GADBannerView!
    
    var source = "shipping-news"
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    @IBAction func searchBackPressed(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }

   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.delegate = self
      searchBar.resignFirstResponder()
        let searchTerm = searchBarNew.text
        //print(searchTerm)
        let finalSearchTerm = searchTerm?.replacingOccurrences(of: " ", with: "+")
        // source = finalSearchTerm!
    self.label.removeFromSuperview()
        fetchArticles(fromSouce: finalSearchTerm!)
    self.view.endEditing(true)
    
   }
   
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 150, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 150, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
//        effectView.addSubview(activityIndicator)
//        effectView.addSubview(strLabel)
//        view.addSubview(effectView)
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        if(currentReachabilityStatus != .notReachable) {
            
            label.center = CGPoint(x: 170, y: 285)
            label.textAlignment = .center
            label.text = "Search Above"
            label.textColor = UIColor.gray
            self.view.addSubview(label)
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerAdSearch.adUnitID = "ca-app-pub-3904893075452390/1951730882"
            bannerAdSearch.rootViewController = self
            bannerAdSearch.load(request)
        }
            
        else{
            print("Not Connected")
            
            self.showAlert(title: "No Internet Connection", message: "Please check your network connection and try again.")
        }
    }
    func fetchArticles(fromSouce provider: String){
          activityIndicator("Searching...")
        let urlRequest = URLRequest(url: URL(string:"http://www.marineinsight.com/?s=\(provider)&json=1&count=20")!)
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
                   // self.refresher.endRefreshing()
                    self.searchTableView.reloadData()
                    self.effectView.removeFromSuperview()
                    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    
                }
                
            }
            catch let error{
                print(error)
            }
            
        }
        
        task.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         //  let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil) as! SearchTableViewCell
           let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
            cell.postTitle.text = self.articles?[indexPath.item].title?.html2AttributedString?.string
        //   cell.imageView?.downloadImage(from: (self.articles?[indexPath.item].topImgUrl!)!)
            return cell
            
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailViewController
        let contentToParse = self.articles?[indexPath.item].content
        let contentToDisplay = NSString(format: "%@%@%@", self, "<style type='text/css'>img {width: 300px; height: auto;} iframe {width: 300px; height: auto;}img.wp-image-42223{display:none;} .wp-caption-text{font-size:5px;}</style>", contentToParse! ) as String
        webVC.detailTitle = self.articles?[indexPath.item].title?.html2AttributedString?.string
        webVC.authorName = self.articles?[indexPath.item].author
        webVC.url = self.articles?[indexPath.item].url
        webVC.detailContent = contentToDisplay
        self.present(webVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

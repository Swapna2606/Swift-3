//
//  DetailViewController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 28/04/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate{

    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var titleLabel: UILabel!
    var scrollView: UIScrollView!
    
    @IBOutlet var bannerAdDetail: GADBannerView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var authorLabel: UILabel!
    
    var url: String?
    var detailTitle:String?
    var detailContent:String?
    var authorName:String?
    let marineInsight:String? = " - Marine Insight"
    let author:String? = "Author: "
    
  
    @IBAction func shareActivity(_ sender: Any) {
        
        let shareTitle:String = detailTitle! + marineInsight! as String
        let shareURL:URL = URL(string: url!)!
        
        let shareItems:NSArray = [shareTitle,shareURL]
        let shareVC:UIActivityViewController = UIActivityViewController(activityItems: shareItems as! [Any], applicationActivities: nil)
        shareVC.excludedActivityTypes = [UIActivityType.postToWeibo,UIActivityType.copyToPasteboard,UIActivityType.addToReadingList]
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @IBAction func saveForOffline(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Save For Offline", message: "Do you want to save: \(String(describing: detailTitle!))", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
             let saveSingleArticle = SaveArticle(saveTitle: self.detailTitle!, saveContent: self.detailContent!, saveAuthor: self.authorName!, saveUrl: self.url!)
            if UserDefaults.standard.data(forKey: "newSave") == nil{
                var savedArticlesArray : [SaveArticle] = []
                savedArticlesArray.append(saveSingleArticle)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: savedArticlesArray)
                UserDefaults.standard.set(encodedData, forKey: "newSave")
                UserDefaults.standard.synchronize()
               // print("Saved 1st article")
            }
            else{
                 var encodedData = UserDefaults.standard.data(forKey: "newSave")
                let savedArticlesArray = (NSKeyedUnarchiver.unarchiveObject(with: encodedData!) as? [SaveArticle])!
                var tempArray: [AnyObject] = (savedArticlesArray as [AnyObject])
                tempArray.append(saveSingleArticle)
                encodedData = NSKeyedArchiver.archivedData(withRootObject: tempArray)
                UserDefaults.standard.set(encodedData, forKey: "newSave")
                UserDefaults.standard.synchronize()
                //print("Updated Array")
           
            }
          
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
/*    func loadArtilce() {
      
        guard let encodedData = UserDefaults.standard.object(forKey: "newSave") as? NSData else {
            print("'places' not found in UserDefaults")
            return
        }
        
        guard let saveArticlesArray = NSKeyedUnarchiver.unarchiveObject(with: encodedData as Data) as? [SaveArticle] else {
            print("Could not unarchive from placesData")
            return
        }
        
        for article in saveArticlesArray {
            print("")
            print("title: \(article.saveTitle)")
            print("content: \(article.saveContent)")
            print("url: \(article.saveUrl)")
        }

    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAdDetail.adUnitID = "ca-app-pub-3904893075452390/1951730882"
        bannerAdDetail.rootViewController = self
        bannerAdDetail.load(request)
        titleLabel.text = detailTitle
        authorLabel.text = author! + authorName!
        webView.loadRequest(URLRequest(url: URL(string:url!)!))
        webView.loadHTMLString(detailContent!, baseURL: nil)
        webView.scrollView.delegate = self
        webView.delegate = self
}
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.showsHorizontalScrollIndicator = false
    }
 
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }

}

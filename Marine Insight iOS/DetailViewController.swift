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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAdDetail.adUnitID = "ca-app-pub-3904893075452390/1951730882"
        bannerAdDetail.rootViewController = self
        bannerAdDetail.load(request)
        titleLabel.text = detailTitle
        authorLabel.text = author! + authorName!
//        webView.scrollView.delegate = self
//        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.loadRequest(URLRequest(url: URL(string:url!)!))
        webView.loadHTMLString(detailContent!, baseURL: nil)
       // webView.scrollView.sizeToFit()
           }
      func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            let horOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            scrollView.setContentOffset(horOffset, animated: true)
        }
    }

}

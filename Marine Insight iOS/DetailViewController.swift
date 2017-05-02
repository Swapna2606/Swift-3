//
//  DetailViewController.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 28/04/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var titleLabel: UILabel!
    
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
        titleLabel.text = detailTitle
        authorLabel.text = author! + authorName!
      //webView.loadRequest(URLRequest(url: URL(string:url!)!))
        webView.loadHTMLString(detailContent!, baseURL: nil)

           }

}

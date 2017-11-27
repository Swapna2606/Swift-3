//
//  OffDetailViewController.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 14/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class OffDetailViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
 
    
    @IBOutlet weak var offTitleLabel: UILabel!
    @IBOutlet weak var offWebView: UIWebView!
    @IBOutlet weak var offAuthorLabel: UILabel!
    var scrollView: UIScrollView!
    
   
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    var offUrl: String?
    var offDetailTitle:String?
    var offDetailContent:String?
    var offAuthName:String?
   // let author = "Author: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Off Detail Loaded")
      offTitleLabel.text = offDetailTitle
        offAuthorLabel.text = "Author: \(String(describing: offAuthName))"
        offWebView.loadRequest(URLRequest(url: URL(string:offUrl!)!))
        offWebView.loadHTMLString(offDetailContent!, baseURL: nil)
        offWebView.scrollView.delegate = self
        offWebView.scrollView.showsHorizontalScrollIndicator = false
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.offWebView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    
}


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
        //print("Off Detail Loaded")
        offTitleLabel.text = offDetailTitle
        offAuthorLabel.text = "Author: \(String(describing: offAuthName!))"
        offWebView.loadRequest(URLRequest(url: URL(string:offUrl!)!))
        offWebView.loadHTMLString(offDetailContent!, baseURL: nil)
        offWebView.scrollView.delegate = self
        offWebView.scrollView.showsHorizontalScrollIndicator = false
        offWebView.delegate = self
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.offWebView.scrollView.showsHorizontalScrollIndicator = false
    }
    // Swift 3
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


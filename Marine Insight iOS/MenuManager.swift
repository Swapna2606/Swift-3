//
//  MenuManager.swift
//  Marine Insight iOS
//
//  Created by raunek kantharia on 02/05/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    let blackView = UIView()
    let menuTableView = UITableView()
    let arrayOfCategories = ["News", "Videos", "Marine Tech", "Navigation", "Guidelines", "Naval Arch", "Safety", "Careers", "Life At Sea", "Piracy", "Real Life Incidents"]
    let arrayOfSlugs = ["shipping-news", "videos", "tech", "marine-navigation", "guidelines", "naval-architecture", "marine-safety", "careers-2", "life-at-sea", "marine-piracy-marine", "case-studies"]
    var mainVC: ViewController?
    
    public func openMenu(){
    
        if let window = UIApplication.shared.keyWindow{
        blackView.frame = window.frame
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu)))
        
        let heightofMenuTableView:CGFloat = 550
            
        let positionofMenu = window.frame.height - heightofMenuTableView
            
        menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: heightofMenuTableView)
            
        window.addSubview(blackView)
        window.addSubview(menuTableView)
            
        UIView.animate(withDuration: 0.5, animations: {
             self.blackView.alpha = 1
            self.menuTableView.frame.origin.y = positionofMenu
                
            })
        }
    }
    
    @objc public func dismissMenu(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow{
            self.menuTableView.frame.origin.y = window.frame.height
            }
        })
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = arrayOfCategories[indexPath.item] as String
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC{
        vc.source = arrayOfSlugs [indexPath.item]
        vc.fetchArticles(fromSouce: arrayOfSlugs[indexPath.item])
        dismissMenu()
        }
    }
    
    override init() {
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        menuTableView.register(MenuViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
}

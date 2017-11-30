//
//  OfflineViewController.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 13/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var offTableView: UITableView!

    var offTitleLabel:String = ""
    var offContent:String = ""
    var offAuthor:String = ""
    var offUrl:String = ""
    var saveArticlesArray = [SaveArticle]()
    var encodedData:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //print(saveArticlesArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
     //   encodedData = UserDefaults.standard.object(forKey: "newSave") as? NSData
        encodedData = UserDefaults.standard.data(forKey: "newSave")
        saveArticlesArray = (NSKeyedUnarchiver.unarchiveObject(with: encodedData!) as? [SaveArticle])!
        if saveArticlesArray.count == 0 {
            offTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        offTableView.reloadData()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveArticlesArray.count
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OfflineCell", for: indexPath) as! OfflineTableViewCell
       cell.offTitle.text = saveArticlesArray[indexPath.row].saveTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let offWebVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "offDetail") as! OffDetailViewController
        offWebVC.offDetailTitle = saveArticlesArray[indexPath.row].saveTitle?.html2AttributedString?.string
        offWebVC.offAuthName = saveArticlesArray[indexPath.row].saveAuthor
        offWebVC.offUrl = saveArticlesArray[indexPath.row].saveUrl
        offWebVC.offDetailContent = saveArticlesArray[indexPath.row].saveContent
        self.present(offWebVC, animated: true, completion: nil)
      
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == UITableViewCellEditingStyle.delete{
            saveArticlesArray.remove(at: indexPath.row)
            DispatchQueue.main.async{
                print("reached dispacth")
                //self.offTableView.reloadData()
                tableView.reloadData()
            }
            
           // encodedData = NSKeyedArchiver.archivedData(withRootObject: saveArticlesArray) as NSData
            encodedData = NSKeyedArchiver.archivedData(withRootObject: saveArticlesArray)
            UserDefaults.standard.set(encodedData, forKey: "newSave")
            UserDefaults.standard.synchronize()
        }
       
    }


}

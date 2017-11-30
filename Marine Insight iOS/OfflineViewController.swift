//
//  OfflineViewController.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 13/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var offTitleLabel:String = ""
    var offContent:String = ""
    var offAuthor:String = ""
    var offUrl:String = ""
    var saveArticlesArray = [SaveArticle]()
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let encodedData = UserDefaults.standard.object(forKey: "newSave") as? NSData
        saveArticlesArray = (NSKeyedUnarchiver.unarchiveObject(with: encodedData! as Data) as? [SaveArticle])!
        //print(saveArticlesArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      tableView.reloadData()
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
       // let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "OfflineCell") as! OfflineTableViewCell
       // cell.textLabel?.text = saveArticlesArray[indexPath.row].saveTitle
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

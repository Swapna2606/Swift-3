//
//  NoInternetViewController.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 27/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    @IBOutlet weak var noInternetLabel: UILabel!
    @IBAction func openSavedStories(_ sender: Any) {
        let offVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "offVC") as! OfflineViewController
        self.present(offVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

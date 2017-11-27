//
//  SaveArticle.swift
//  Marine Insight iOS
//
//  Created by Raunek Kantharia on 13/11/17.
//  Copyright © 2017 marineinsight. All rights reserved.
//

import UIKit

class SaveArticle: NSObject, NSCoding {
    var saveTitle: String?
    var saveContent: String?
    var saveAuthor: String?
    var saveUrl: String?
//    var saveThumbnail: String?
//    var SaveTopImgUrl:String?


init(saveTitle: String, saveContent: String, saveAuthor: String, saveUrl: String) {
 self.saveTitle = saveTitle
    self.saveContent = saveContent
    self.saveAuthor = saveAuthor
    self.saveUrl = saveUrl
}
    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        saveTitle = aDecoder.decodeObject(forKey: "saveTitle") as? String
        saveContent = aDecoder.decodeObject(forKey: "saveContent") as? String
        saveAuthor = aDecoder.decodeObject(forKey: "saveAuthor") as? String
        saveUrl = aDecoder.decodeObject(forKey: "saveUrl") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(saveTitle, forKey: "saveTitle")
        aCoder.encode(saveContent, forKey: "saveContent")
        aCoder.encode(saveAuthor, forKey: "saveAuthor")
        aCoder.encode(saveUrl, forKey: "saveUrl")
    }
}

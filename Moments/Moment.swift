//
//  Moment.swift
//  Moments
//
//  Created by HooJackie on 4/5/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import Foundation
import UIKit

class Moment:NSObject,NSCoding {

    
    var text:String
    var date:String
    var image:UIImage
    
    init(text:String,date:String,image:UIImage){
        self.text = text
        self.date = date
        self.image = image
    }
    override init(){
        self.text = ""
        self.date = ""
        self.image = UIImage()
    }
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.text, forKey: "text")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.image, forKey: "image")
    }
    required init?(coder aDecoder: NSCoder){
        self.text = aDecoder.decodeObjectForKey("text") as! String
        self.date = aDecoder.decodeObjectForKey("date") as! String
        self.image = aDecoder.decodeObjectForKey("image") as! UIImage
        super.init()
    }

}

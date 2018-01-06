//
//  classFile.swift
//  PessangerApp
//
//  Created by Dhruvil Patel on 9/4/17.
//  Copyright © 2017 Dhruvil. All rights reserved.
//

import Foundation


class AuctionName1: NSObject {
    
    
    var auctionid : String
    var auctionname : String
    var userd : String
    var userp : String
    var dlocation : String
    var plocation : String
    var pdestination : String
    var price : Int
    var id : String
    
    
    init(auctionname : String, auctionid : String, userd : String, userp : String, dlocation : String, plocation : String, pdestination: String, price :Int, id : String) {
        self.auctionname = auctionname
        self.auctionid = auctionid
        self.userd = userd
        self.userp = userp
        self.dlocation = dlocation
        self.plocation = plocation
        self.pdestination = pdestination
        self.price = price
        self.id = id
        
        
    }
    
}

//
//  LastViewController.swift
//  PessangerApp
//
//  Created by Dhruvil Patel on 11/7/17.
//  Copyright © 2017 Dhruvil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LastViewController: UIViewController {
    
    var bid1 = ""
    var auctionname1 = ""
    var auctionid1 = ""
    var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData1()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(LastViewController.parseData1), for: UIControlEvents.valueChanged)
        //tableView.addSubview(refresher)
    }
    
    
    @IBOutlet weak var lbl: UILabel!
    @IBAction func signOutAction(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    var fetchAuctionName1 = [AuctionName1]()
    @objc func parseData1() {
        
        let url = "https://app-auction-17.appspot.com/_ah/api/auctionWinnerApi/v1/auctionwinner"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil){
                print("Error")
            }
            else{
                
                do{
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    let jsonArray = fetchData.value(forKey: "items") as! NSArray
                    
                    for eachFetchedAuctionName in jsonArray {
                        
                        let eachAuctionName1 = eachFetchedAuctionName as! [String : Any]
                        let auctionid = eachAuctionName1["auctionID"] as! String
                        let auctionname = eachAuctionName1["auctionName"] as! String
                        let userd = eachAuctionName1["userD"] as! String
                        let userp = eachAuctionName1["userP"] as! String
                        let dlocation = eachAuctionName1["dlocation"]as! String
                        let plocation = eachAuctionName1["plocation"]as! String
                        let pdestination = eachAuctionName1["pdestination"]as! String
                        let id = eachAuctionName1["id"]as! String
                        
                        
                        if(eachAuctionName1["auctionID"] as! String == self.auctionid1)
                        {
                            self.fetchAuctionName1.append(AuctionName1(auctionname:auctionname, auctionid:auctionid, userd:userd, userp:userp, dlocation:dlocation, plocation:plocation, pdestination:pdestination, id:id));
                            print("auctionwinnerid \(auctionid)")
                            print("auctionwinnername \(auctionname)")
                            print(userp)
                            
                            self.lbl.text = "You win Auction: \(auctionname) your Pessenger: \(userp), Pessenger Location: \(plocation)"
                            
                            self.refresher.endRefreshing()
                        }
                        else
                        {
                            self.lbl.text = "Sorry you loss the Auction.... May be next time.....!!!"
                        }
                        
                    }
                    
                }
                catch{
                    print("Error 2")
                }
            }
            
        }
        task.resume()
       
    }
    
    class AuctionName1: NSObject {
        
        var auctionid : String
        var auctionname : String
        var userd : String
        var userp : String
        var dlocation : String
        var plocation : String
        var pdestination : String
        var id : String
        
        
        init(auctionname : String, auctionid : String, userd : String, userp : String, dlocation : String, plocation : String, pdestination: String, id : String) {
            self.auctionname = auctionname
            self.auctionid = auctionid
            self.userd = userd
            self.userp = userp
            self.dlocation = dlocation
            self.plocation = plocation
            self.pdestination = pdestination
            self.id = id
        }
    }
    
}


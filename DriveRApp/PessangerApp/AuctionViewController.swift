//
//  AuctionViewController.swift
//  PessangerApp
//
//  Created by Dhruvil Patel on 7/21/17.
//  Copyright © 2017 Dhruvil. All rights reserved.
//

import UIKit

class AuctionViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var auctionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auctionTableView.dataSource = self
        
        parseData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if let desitnation = segue.destination as? DetailedAuctionView {
            
            desitnation.name = fetchAuctionName[auctionTableView.indexPathForSelectedRow!.row].auctionname;
            desitnation.id = fetchAuctionName[auctionTableView.indexPathForSelectedRow!.row].auctionid;
            desitnation.endt = fetchAuctionName[auctionTableView.indexPathForSelectedRow!.row].endtime;
           
        }
        
        
        
    }
    
    
    var fetchAuctionName = [AuctionName]()
 
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchAuctionName.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = auctionTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = fetchAuctionName[indexPath.row].auctionname
        cell?.detailTextLabel?.text = nil
        
        return cell!
    }
    
    func parseData() {
        
        fetchAuctionName = []
        
        let url = "https://app-auction-17.appspot.com/_ah/api/auctionTimeApi/v1/auctiontimecollection"
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
                        
                        let eachAuctionName = eachFetchedAuctionName as! [String : Any]
                        
                        let auctionname = eachAuctionName["auctionName"] as! String
                        let auctionid = eachAuctionName["id"] as! String
                        let endtime = eachAuctionName["endTime"] as! String
                        
                        if(eachAuctionName["status"] as! Int == 0)
                        {
                            self.fetchAuctionName.append(AuctionName(auctionname: auctionname, auctionid : auctionid, endtime: endtime));
                            //  self.fetchAuctionName.append(AuctionName(auctionid: auctionid));
                        }
                        
                    }
                    
                    
                    self.auctionTableView.reloadData()
                    
                }
                catch{
                    print("Error 2")
                }
            }
            
        }
        task.resume()
        
    }
    
}
class AuctionName: NSObject {
    
    var auctionname : String
    var auctionid : String
    var endtime : String
    
    init(auctionname : String, auctionid : String, endtime : String) {
        self.auctionname = auctionname
        self.auctionid = auctionid
        self.endtime = endtime
        
    }


  

  
}

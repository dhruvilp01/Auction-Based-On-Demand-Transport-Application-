//
//  DetailedAuctionView.swift
//  PessangerApp
//
//  Created by Dhruvil Patel on 7/21/17.
//  Copyright © 2017 Dhruvil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit
import CoreLocation

class DetailedAuctionView: UIViewController,UITextFieldDelegate,  UISearchBarDelegate, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var enterBidText: UITextField!
    
    @IBOutlet weak var enterPickupLocationText: UITextField!
    
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var EnterDropLocationText: UITextField!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    
    var name = ""
    var id = ""
    var endt = ""
    var ref: DatabaseReference!
    var refHandle: UInt!
    var timer = Timer()
    var currenttext = ""
    var desttext = ""

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC1 = segue.destination as! LastViewController
        destVC1.auctionname1 = name
        destVC1.bid1 = enterBidText.text!
        destVC1.auctionid1 = id
       
        
    }
      var username2 = [String]()
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // parseData1()
    
        enterPickupLocationText.delegate = self
        enterBidText.delegate = self
        EnterDropLocationText.delegate = self

        print("Auction Name  = \(name)")
        print("Auction ID  = \(id)")
        print ("Auction Endtime = \(endt)")
        
        ref = Database.database().reference()
        
        
        let userId: String = (Auth.auth().currentUser?.uid)!
        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let post = value?["type"] as? String ?? ""
            
            self.username2.append(post)
            
            print(self.username2[0])
           
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DetailedAuctionView.counter), userInfo: nil, repeats: true)

            self.enterPickupLocationText.text = self.currenttext
            self.EnterDropLocationText.text = self.desttext
            
        })
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
     
    }
    
    func counter () {
       
         let endtD = Double(endt)
        let date = Date()
        //print("e is ",endtD!)
        let a : Double = date.timeIntervalSince1970 * 1000
        //print("a is ", a)
        let q : Double = endtD! - a
        let x = Int(q) / 1000
        let y = String(x)
        print("y is \(y)")
        let hour = x / 3600
        let minute = (x % 3600) / 60
        var second = ((x % 3600) % 60)
        let z = ("\(hour):\(minute):\(second)")
        self.timerLbl.text = z
        
        second -= 1
        if second == 0 && hour == 0 && minute == 0 {
            
                    timer.invalidate()
            
            let alertController = UIAlertController(title: "Auction End", message: "Auction Time is Over", preferredStyle: .alert)
            
            let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let acceptAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                
                self.performSegue(withIdentifier: "PlaceBid", sender: self) // Replace SomeSegue with your segue identifier (name)
            }
            
            alertController.addAction(declineAction)
            alertController.addAction(acceptAction)
            
            present(alertController, animated: true, completion: nil)
            
                }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterPickupLocationText.resignFirstResponder()
        enterBidText.resignFirstResponder()
        EnterDropLocationText.resignFirstResponder()
    }
  
    @IBAction func tappedPlacedBidButton(_ sender: Any) {
        
        timer.invalidate()
        
        data_request("https://app-auction-17.appspot.com/_ah/api/auctionApi/v1/auctionInsert")
        
        
          let alertController = UIAlertController(title: "Successfully", message: "You Placed for Auction Name:\(name) for \(enterBidText.text!) ", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.performSegue(withIdentifier: "SignOut1", sender: self) })
        //alert.addAction(UIAlertAction(title:"OK", style: .Default, handler:  { action in self.performSegueWithIdentifier("mySegueIdentifier", sender: self) }
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
   
    func data_request(_ url:String)
    {
        
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        
        let url:NSURL = NSURL(string: url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let paramString = "auctionName=\(name)&bid=\(enterBidText.text!)&dlocation=&pdestination=\(EnterDropLocationText.text!)&plocation=\(enterPickupLocationText.text!)&regisID=\(token ?? "")&type=Passenger&userID=\(username2[0])&auctionID=\(id)"
          
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
            
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            {
                print(dataString)
            }
        }
        

        task.resume()
            
        
    }
   
    @IBAction func signOutAction(_ sender: Any) {
        
        //parseData1()
        
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
 
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
                
                let geoCoder = CLGeocoder()
                let location1 = CLLocation(latitude: latitude!, longitude: longitude!)
                
                geoCoder.reverseGeocodeLocation(location1, completionHandler: { (placemarks, error) -> Void in
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    
                    // Address dictionary
                    print(placeMark.addressDictionary as Any)
                    
                    // Location name
                    let locationName = placeMark.addressDictionary!["Name"] as? NSString
                    print(locationName!)
                    
                    // Street address
                    let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString
                    print(street!)
                    
                    // City
                    let city = placeMark.addressDictionary!["City"] as? NSString
                    print(city!)
                    
                    // Zip code
                    let zip = placeMark.addressDictionary!["ZIP"] as? NSString
                    print(zip!)
                    
                    // Country
                    let country = placeMark.addressDictionary!["Country"] as? NSString
                    print(country!)
                    
                    let a = "\(locationName!),\(street!),\(city!)"
                    self.EnterDropLocationText.text = a
                })
                
                
            }
            
        }


    }
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        myMapView.setRegion(region, animated: true)
        
        print(location.altitude)
        print(location.speed)
        
        let geoCoder = CLGeocoder()
        //let location1 = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            let locationName = placeMark.addressDictionary!["Name"] as? NSString
            print(locationName!)
            
            // Street address
            let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString
            print(street!)
            
            // City
            let city = placeMark.addressDictionary!["City"] as? NSString
            print(city!)
            
            // Zip code
            let zip = placeMark.addressDictionary!["ZIP"] as? NSString
            print(zip!)
            
            // Country
            let country = placeMark.addressDictionary!["Country"] as? NSString
            print(country!)
            
            let a = "\(locationName!),\(street!),\(city!)"
            
            self.enterPickupLocationText.text = a
        })
        
        self.myMapView.showsUserLocation = true
        
    }


}

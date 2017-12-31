//
//  StudyHoursViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/23/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import CoreLocation
import SWRevealViewController
import GooglePlacePicker
import AWSDynamoDB
import AWSCognitoIdentityProvider
import EPSignature

class StudyHoursViewController: UIViewController, CLLocationManagerDelegate, EPSignatureDelegate {

    @IBOutlet weak var sideMenu: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var selectClassButton: LeftAlignedIconButton!
    @IBOutlet weak var startStopStudyingButton: LeftAlignedIconButton!
    @IBOutlet weak var timer: UILabel!
    
    let locationManager = CLLocationManager()
    
    var initalLocation:CLLocationCoordinate2D!
    
    var locationSet: Bool!
    var classSet:Bool!
    var classDescription: String!
    var studying:Bool = false
    var timerCounter: Timer?
    
    var locationName:String!
    
    var lastName: String!
    var firstName: String!
    var proboLevel: String!
    
    var seconds = 0
    var minutes = 0
    var hours = 0
    var days = 0
    
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewSignature: UIImageView!
    
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
        
        // S3 Intializations
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"us-east-1:bb023064-cbc1-40da-8cfc-84cc04d5485f")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Other AWS Stuff
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        self.refresh()
        
        locationSet = false
        classSet = false
        
        super.viewDidLoad()
        
        setupNavBarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavBarButtons() {
        if self.revealViewController() != nil {
            sideMenu.target = self.revealViewController()
            sideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = self.view.frame.width * 0.7 < 290 ? self.view.frame.width * 0.7 : 290
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            settings.target = self.revealViewController()
            settings.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.7 < 290 ? self.view.frame.width * 0.7 : 290
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func pickPlace(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        print(locValue)
        initalLocation = locValue
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude) 
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //mapView.settings.scrollGestures = false
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                // self.nameLabel.text = place.name
                // self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n")
                print(locValue)
                print("----------------------")
                print(place.name)
                self.locationName = place.name
                print(place.coordinate)
                print("----------------------")
                print(self.compareCoordinates(place.coordinate, locValue))
                
                if(!self.compareCoordinates(place.coordinate, locValue)){
                    let alert = UIAlertController(title: "Invalid Location!", message: "The location you chose is too far away from your current location.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in  }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.locationSet = true
                }
            }
        })
    }
 
    
    @IBAction func selectClass(_ sender: Any) {
    
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter Your Class", message: "This should either be the subject or the course number (e.g. CS 159)", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.textAlignment = .center
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField!.text))")
            if(textField!.text != ""){
                self.classDescription = textField!.text
                self.classSet = true
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func compareCoordinates(_ cllc2d1 : CLLocationCoordinate2D, _ cllc2d2 : CLLocationCoordinate2D) -> Bool {
        
        let epsilon = 0.00075
        
        print("fabs 1: \(fabs(cllc2d1.latitude - cllc2d2.latitude))")
        print("fabs 2: \(fabs(cllc2d1.longitude - cllc2d2.longitude))")
        
        return  fabs(cllc2d1.latitude - cllc2d2.latitude) <= epsilon && fabs(cllc2d1.longitude - cllc2d2.longitude) <= epsilon
    }
    
    @IBAction func startStudying(_ sender: Any) {
        if(!studying){
            if(locationSet && classSet) {
                studying = true
                startStopStudyingButton.setTitle("Stop Studying", for: .normal)
                if (timerCounter == nil){
                    timerCounter = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(StudyHoursViewController.updateCounter), userInfo: nil, repeats: true)
                }
            } else {
                let alert = UIAlertController(title: "Parameters Not Set", message: "Both location and class must be set for study hours to count", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if(studying){
            if(timerCounter != nil){
                timerCounter!.invalidate()
                timerCounter = nil
            }
            let alert = UIAlertController(title: "Finish Studying", message: "Press submit to log hours. Press cancel to discard hours.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: logHours))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: resetValues))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func resetValues(_ alert: UIAlertAction) {
        if(timerCounter != nil){
            timerCounter!.invalidate()
            timerCounter = nil
        }
        startStopStudyingButton.setTitle("Start Studying", for: .normal)
        locationSet = false
        classSet = false
        studying = !studying
        timer.text! = ""
        seconds = 0
        minutes = 0
        hours = 0
        days = 0
    }
    
    func logHours(_ alert: UIAlertAction) {
        if(timerCounter != nil){
            timerCounter!.invalidate()
            timerCounter = nil
        }
        startStopStudyingButton.setTitle("Start Studying", for: .normal)
        locationSet = false
        classSet = false
        studying = !studying
        timer.text! = ""
        seconds = 0
        minutes = 0
        hours = 0
        days = 0
        
        // logging
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        if(!self.compareCoordinates(self.initalLocation, locValue)){
            let alert = UIAlertController(title: "Invalid Location!", message: "You've moved too far away from your initial study location. These study hours are invalid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in  }))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            for index in 1..<(self.response?.userAttributes?.count)! {
                print("index: \(index)")
                var userAttribute = self.response?.userAttributes![index]
                print("name: \(userAttribute?.name)")
                print("value: \(userAttribute?.value)")
                
                if(userAttribute?.name! == "custom:probo_level") {
                    print("XXXcustomProboLevel")
                    proboLevel = userAttribute?.value!
                }
                if(userAttribute?.name! == "given_name") {
                    print("XXXfirstName")
                    firstName = userAttribute?.value!
                }
                if(userAttribute?.name! == "family_name") {
                    print("XXXlastName")
                    lastName = userAttribute?.value!
                }
                
            }
            
            let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: false)
            signatureVC.subtitleText = "I affirm that \(firstName! + " " + lastName!) has studied \((Double(days * 24 + hours) + Double(minutes)/60)) hours at \(locationName!)"
            signatureVC.title = firstName! + " " + lastName!
            let nav = UINavigationController(rootViewController: signatureVC)
            present(nav, animated: true, completion: nil)
        }
    }
    
    func insertTableRow(_ tableRow: DDBTableRow) {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDBObjectMapper.save(tableRow) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as NSError? {
                print("Error: \(error)")
                
                let alertController = UIAlertController(title: "Failed to submit study hours.", message: "Text the scholarship chair.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Succeeded", message: "Successfully submitted study hours.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                //self.dataChanged = true
            }
            
            return nil
        })
    }
    
    
    @objc func updateCounter() {
        seconds = (seconds + 1) % 60
        if(seconds == 0){
            minutes = (minutes + 1) % 60
            if(minutes == 0){
                hours = (hours + 1) % 24
                if(hours == 0){
                    days += 1
                }
            }
        }
        timer.text! = String(format: "%02d", days)
            + ":" + String(format: "%02d", hours)
            + ":" + String(format: "%02d", minutes)
            + ":" + String(format: "%02d", seconds)
    }
    
    class DDBTableRow :AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
        
        var UniqueID:NSNumber?
        var Name:String?
        
        //set the default values of scores, wins and losses to 0
        var Class:String? = ""
        var Hours:NSNumber? = 0
        var Location:String? = ""
        var Week:NSNumber? = 0
        var Probo_Level:String? = ""
        
        //should be ignored according to ignoreAttributes
        var internalName:String?
        var internalState:NSNumber?
        
        class func dynamoDBTableName() -> String {
            return "Probo_Study_Hours"
        }
        
        class func hashKeyAttribute() -> String {
            return "UniqueID"
        }
        
        class func rangeKeyAttribute() -> String {
            return "Name"
        }
        
        class func ignoreAttributes() -> [String] {
            return ["internalName", "internalState"]
        }
    }
    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
            })
            return nil
        }
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        imgViewSignature.image = signatureImage
        imgWidthConstraint.constant = boundingRect.size.width
        imgHeightConstraint.constant = boundingRect.size.height
        submitData()
    }
    
    func submitData() {
        
        let date = Date() // now
        let cal = Calendar.current
        let day:Int = cal.ordinality(of: .day, in: .year, for: date)!
        print(day)
        
        let tableRow = DDBTableRow()
        tableRow?.UniqueID = arc4random() as NSNumber?
        tableRow?.Name = firstName! + " " + lastName! as String?
        tableRow?.Probo_Level = proboLevel! as String?
        tableRow?.Class = classDescription as String?
        tableRow?.Hours = (Double(days * 24 + hours) + Double(minutes)/60) as NSNumber?
        tableRow?.Location = locationName
        tableRow?.Week = (day/7 - 1) as NSNumber?
        
        self.insertTableRow(tableRow!)
        
        print("logged!")
    }
}

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        var availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        availableWidth -= (imageView?.frame.width)!
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth/2, bottom: 0, right: 0)
    }
}

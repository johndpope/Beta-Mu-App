//
//  SideMenuTableViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/22/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class SideMenuTableViewController: UITableViewController {
    
    struct SideMenuSections {
        var sectionName : String!
        var sectionLabels : [String]!
    }
    
    var sideMenuArr = [SideMenuSections]()
    
    // MARK: Properties
    var sideMenuViews: [String] =
    ["Announcements",
    "Notifications",
    "Calendar",
    "Fines",
    "Dishes",
    "Sober Duty",
    "Study Hours",
    "Social",
    "Messaging",
    "Exec Requests",
    "Community Service",
    "Philanthropy",
    "Beta Songs",
    "Bylaws"
    ]
    
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    var lastName: String!
    var firstName: String!
    var proficlePicURL: String!
    var brotherStatus: String!
    var pinNumber: String!
    
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var last: UILabel!
    @IBOutlet weak var brother: UILabel!
    
    let cellIdentifier = "SideMenuTableViewCell"
    
    var currentBackground: UIColor!
    
    func setSideMenuSections() {
        sideMenuArr = [
            SideMenuSections(sectionName: "General",
                             sectionLabels: sideMenuViews)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSideMenuSections()
        
        //self.automaticallyAdjustsScrollViewInsets = false

        self.tableView.contentInsetAdjustmentBehavior = .never
        
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.clear.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        userImage.isUserInteractionEnabled = true
        userImage.contentMode = .scaleAspectFit
        
        // Other AWS Stuff
        self.pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        self.refresh()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getCognitoValue()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.setHeader()
            }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let statusBarView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor.black
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getCognitoValue()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.setHeader()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor.init(displayP3Red: 31/255, green: 58/255, blue: 87/255, alpha: 1.0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sideMenuArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuArr[section].sectionLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SideMenuTableViewCell

        // Table view cells are reused and should be dequeued using a cell identifier.
        
        cell.viewLabel.text = sideMenuArr[indexPath.section].sectionLabels[indexPath.row]
        cell.backgroundColor = hexStringToUIColor(hex: "22c1fa")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //cell?.backgroundColor = UIColor(white: 1, alpha: 0.25)
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sideMenuArr[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = hexStringToUIColor(hex: "20b1f8")
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black.withAlphaComponent(0.4)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if(indexPath.row == 0){
            //self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "announcementSegue", sender: self)
        }
        if(indexPath.row == 1){
            self.performSegue(withIdentifier: "notificationSegue", sender: self)
        } */
        
        if(indexPath.row == 6){
            self.performSegue(withIdentifier: "studyHoursSegue", sender: self)
        }
        // self.performSegue(withIdentifier: "yourIdentifier", sender: self)
    }
    
    func getCognitoValue() {
        for index in 1..<(self.response?.userAttributes?.count)! {
            print("index: \(index)")
            var userAttribute = self.response?.userAttributes![index]
            
            if(userAttribute?.name! == "custom:profile_pic_url") {
                proficlePicURL = userAttribute?.value!
            }
            if(userAttribute?.name! == "given_name") {
                firstName = userAttribute?.value!
            }
            if(userAttribute?.name! == "family_name") {
                lastName = userAttribute?.value!
            }
            if(userAttribute?.name! == "custom:brother_status") {
                brotherStatus = userAttribute?.value!
            }
            if(userAttribute?.name! == "custom:pin_number") {
                pinNumber = userAttribute?.value!
            }
        }
    }
    
    func setHeader() {
        first.text! = firstName
        last.text! = lastName
        
        let brotherStatusText = brotherStatus + ((pinNumber != nil) ? " - " + pinNumber : "")
        
        brother.text! = brotherStatusText
        
        
        if(proficlePicURL != nil) {
            let url = URL(string: (proficlePicURL + ".PNG"))
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.userImage.image = UIImage(data: data!)
                }
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }


}

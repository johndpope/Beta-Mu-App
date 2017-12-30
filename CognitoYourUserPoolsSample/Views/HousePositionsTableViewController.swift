//
//  HousePositionsTableViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class HousePositionsTableViewController: UITableViewController {

    struct HousePositionSections {
        var sectionName : String!
        var sectionPositions : [String]!
    }
    
    var checked = Set<IndexPath>()
    
    var userHousePositions: [String]! = [String]()
    
    var housePosArr = [HousePositionSections]()
    
    func setHousePositionSections() {
        housePosArr = [
            HousePositionSections(sectionName: "Misc. House Positions",
                             sectionPositions: ["President",
                                               "Chapter Counselor",
                                               "IFC Representative",
                                               "Technology Chair",
                                               "Wellness Chair",
                                               "Wellness Committee",
                                               "BMOC Chair",
                                               "BMOC Member"]),
            
            HousePositionSections(sectionName: "Programming",
                             sectionPositions: ["VP of Programming",
                                               "Programming Committee Member",
                                               "Social Chair",
                                               "Social Committee Member",
                                               "Philanthropy Chair",
                                               "Community Service Chair",
                                               "Intramural Chair"]),
            
            HousePositionSections(sectionName: "Brotherhood",
                                  sectionPositions: ["VP of Brotherhood",
                                                    "Brotherhood Chair",
                                                    "Brotherhood Committee Member",
                                                    "Kai Chair",
                                                    "Kai Committee",
                                                    "Scholarship Chair",
                                                    "Scholarship Committee Member",
                                                    "Ritual Chair"]),
            
            HousePositionSections(sectionName: "Education",
                                  sectionPositions: ["VP of Education",
                                                    "Education Chair",
                                                    "Education Committee Member",
                                                    "Active Member Education"]),
            
            HousePositionSections(sectionName: "Recruitment",
                                  sectionPositions: ["VP of Recruitment",
                                                    "Recruitment Committee Member"]),
            
            HousePositionSections(sectionName: "Risk Management",
                                  sectionPositions: ["VP of Risk",
                                                     "Risk Committee Member",
                                                     "House Manager"]),
            
            HousePositionSections(sectionName: "Finance",
                                  sectionPositions: ["VP of Finance",
                                                     "Kitchen Manager"]),
            
            HousePositionSections(sectionName: "Communication",
                                  sectionPositions: ["VP of Communication",
                                                     "Social Media Chair"])
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "housePositionsToRegistrationSegue" {
            if let toViewController = segue.destination as? SignUpViewController
            {
                toViewController.checked = self.checked
                toViewController.userHousePositions = self.userHousePositions
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /* if (year == "Freshman") {
            self.yearPicker.selectRow(0, inComponent:0, animated:true)
        }
        else if(year == "Sophomore"){
            self.yearPicker.selectRow(1, inComponent:0, animated:true)
        }
        else if(year == "Junior"){
            self.yearPicker.selectRow(2, inComponent:0, animated:true)
        }
        else if(year == "Senior"){
            self.yearPicker.selectRow(3, inComponent:0, animated:true)
        }
        else if(year == "Super Senior"){
            self.yearPicker.selectRow(4, inComponent:0, animated:true)
        } */
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setHousePositionSections()
        
        // Uncomment the following line to preserve selection between presentations
         // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return housePosArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return housePosArr[section].sectionPositions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "housePositonsTableViewCell", for: indexPath) as! HousePositionsTableViewCell
        
        cell.label.text = housePosArr[indexPath.section].sectionPositions[indexPath.row]
        
        cell.checkMark.isHidden = !self.checked.contains(indexPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if (!cell.checkMark.isHidden) {
                //print(cell.label.text!)
                self.userHousePositions.append(cell.label.text!)
            } else {
                if(self.userHousePositions != nil){
                    self.userHousePositions = self.userHousePositions.filter{$0 != self.housePosArr[indexPath.section].sectionPositions[indexPath.row]}
                }
            }
            
        }
        
        cell.backgroundColor = hexStringToUIColor(hex: "22c1fa")
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return housePosArr[section].sectionName
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = hexStringToUIColor(hex: "20b1f8")
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.checked.contains(indexPath) {
            self.checked.remove(indexPath)
        } else {
            self.checked.insert(indexPath)
        }
        
        tableView.reloadRows(at:[indexPath], with:.fade)
        
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

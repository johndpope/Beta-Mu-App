//
//  YearSelectionViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import CoreData

class YearSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var year: String!
    var major: String!
    
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var majorText: UITextField!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.yearPicker.dataSource = self
        self.yearPicker.delegate = self
        
        pickerData = [
            "Freshman",
            "Sophomore",
            "Junior",
            "Senior",
            "Super Senior"
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "yearMajorToRegistrationSegue" {
            if let toViewController = segue.destination as? SignUpViewController {
                toViewController.year = self.year
                toViewController.major = self.majorText.text!
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (year == "Freshman") {
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
        }
        
        if (major != "") {
            majorText.text = major
        }
        
        // Year
        print("year_: \(year)")
        print("major_: \(major)")
    }
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        year = pickerData[row]
    }
    
}

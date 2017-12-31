//
//  BrotherStatusViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class BrotherStatusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var brotherStatus: String = "Brother"
    var pinNum: String!
    
    @IBOutlet weak var brotherStatusPicker: UIPickerView!
    @IBOutlet weak var pinNumber: UITextField!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.brotherStatusPicker.dataSource = self
        self.brotherStatusPicker.delegate = self
        
        pickerData = [
            "Brother",
            "Pledge",
            "Neophyte",
        ]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "brotherStatusToRegistrationSegue" {
            if let toViewController = segue.destination as? SignUpViewController {
                toViewController.brotherStatus = self.brotherStatus
                toViewController.pinNum = self.pinNumber.text!
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (brotherStatus == "Brother") {
            self.brotherStatusPicker.selectRow(0, inComponent:0, animated:true)
        }
        else if(brotherStatus == "Pledge"){
            self.brotherStatusPicker.selectRow(1, inComponent:0, animated:true)
        }
        else if(brotherStatus == "Neophyte"){
            self.brotherStatusPicker.selectRow(2, inComponent:0, animated:true)
        }
        
        if (pinNum != "") {
            pinNumber.text = pinNum
        }
        
        print("Brother Status_: \(brotherStatus)")
        print("Pin Number_: \(pinNum)")
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
        
        if(pickerData[row] == "Brother"){
            self.pinNumber.isUserInteractionEnabled = true
        }
        else {
            self.pinNumber.isUserInteractionEnabled = false
            pinNumber.text = ""
        }
        
        brotherStatus = pickerData[row]
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        pinNumber.resignFirstResponder()
        return true
    }
    
    @IBAction func selectBrotherStatus(_ sender: Any) {
        if (pinNumber.text != ""){
            //setPinNumber
        }
    }
    
}

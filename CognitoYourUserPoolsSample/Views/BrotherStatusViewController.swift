//
//  BrotherStatusViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class BrotherStatusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var brotherStatus: String!
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
    
    /* func getCoreData_String(_ attribute: String) -> String {
        var stringArr:[String] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let stringValue = data.value(forKey: attribute) as? String
                {
                    stringArr.append(stringValue)
                }
            }
        } catch {
            print("Failed")
        }
        let count = stringArr.count
        if(count > 0){
            return stringArr[count - 1]
        }
        else{
            return ""
        }
    }
    
    func getCoreData_Int(_ attribute: String) -> Int32 {
        var intArr:[Int32] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let intValue = data.value(forKey: attribute) as? Int32
                {
                    intArr.append(intValue)
                }
            }
        } catch {
            print("Failed")
        }
        let count = intArr.count
        if(count > 0){
            return intArr[count - 1]
        }
        else{
            return 0
        }
    } */
    
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

//
//  ProboLevelViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/25/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class ProboLevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var proboLevelPicker: UIPickerView!
    
    var proboLevel: String = "Not on Probo (GPA >= 2.85)"
    
    var pickerData: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.proboLevelPicker.dataSource = self
        self.proboLevelPicker.delegate = self
        
        pickerData = [
            "Not on Probo (GPA >= 2.85)",
            "Probo 1 (2.85 > GPA >= 2.5)",
            "Probo 2 (2.5 > GPA >= 2.0)",
            "Probo 3 (2.0 > GPA)"
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "proboLevelToRegistrationSegue" {
            if let toViewController = segue.destination as? SignUpViewController {
                toViewController.proboLevel = self.proboLevel
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (proboLevel == "Not on Probo (GPA >= 2.85)") {
            self.proboLevelPicker.selectRow(0, inComponent:0, animated:true)
        }
        else if(proboLevel == "Probo 1 (2.85 > GPA >= 2.5)"){
            self.proboLevelPicker.selectRow(1, inComponent:0, animated:true)
        }
        else if(proboLevel == "Probo 2 (2.5 > GPA >= 2.0)"){
            self.proboLevelPicker.selectRow(2, inComponent:0, animated:true)
        }
        else if(proboLevel == "Probo 3 (2.0 > GPA)"){
            self.proboLevelPicker.selectRow(3, inComponent:0, animated:true)
        }
        else {
            self.proboLevelPicker.selectRow(0, inComponent:0, animated:true)
        }
        
    }
    
    /* func setProboLevel(_ year: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        newUser.setValue(year, forKey: "proboLevel")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    } */
    
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
        proboLevel = pickerData[row]
    }
    
}

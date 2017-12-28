//
//  Announcments_Main_ViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/22/17.
//  Copyright © 2017 James Weber. All rights reserved.

import UIKit
import SWRevealViewController

class Announcments_Main_ViewController: UIViewController {
    
    @IBOutlet weak var sideMenu: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            sideMenu.target = self.revealViewController()
            sideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = self.view.frame.width * 0.7
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            settings.target = self.revealViewController()
            settings.action = #selector(SWRevealViewController.rightRevealToggle(_:))
           self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.7
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView
{
    func viewController() -> UIViewController? {
        var responder : UIResponder? = self
        while let r = responder {
            if r.isKind(of: UIView.self) {
                responder = r.next
            } else {
                break
            }
        }
        return responder as? UIViewController
    }
}

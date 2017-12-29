//
//  NotificationsViewController.swift
//  BetaMuScholarship
//
//  Created by James Weber on 12/28/17.
//  Copyright © 2017 Dubal, Rohan. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendNotification(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "I'm a cunt!"
        content.subtitle = "but..."
        content.body = "Denise is nasty and a bitch!"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    

}

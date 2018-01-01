//
//  TimerView.swift
//  BetaMuScholarship
//
//  Created by James Weber on 1/1/18.
//  Copyright © 2018 Dubal, Rohan. All rights reserved.
//

import UIKit
import PureLayout

class TimerView: UIView {

    var shouldSetupConstraints = true
    
    var timerLabel: UILabel!
    let screenSize = UIScreen.main.bounds
    
    var seconds = 0
    var minutes = 0
    var hours = 0
    var days = 0
    
    var timerCounter: Timer?
    
    var initalView: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timerLabel = UILabel(frame: CGRect.zero)
        timerLabel.text = ""
        timerLabel.textAlignment = .center
        //timerLabel.layer.borderWidth = 2.0
        timerLabel.font = UIFont(name:"Verdana", size: 40.0)
        timerLabel.autoSetDimensions(to: CGSize(width: screenSize.width, height: frame.height))
        
        self.addSubview(timerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateConstraints() {
        if(shouldSetupConstraints) {
            //timerLabel.autoCenterInSuperview()
            timerLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
            timerLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
            timerLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0)
            timerLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)

            shouldSetupConstraints = false
        }
        
        if (timerCounter == nil && initalView){
            timerCounter = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
        
        super.updateConstraints()
    }

    @objc func updateCounter() {
        timerLabel.text! = String(format: "%02d", days)
            + ":" + String(format: "%02d", hours)
            + ":" + String(format: "%02d", minutes)
            + ":" + String(format: "%02d", seconds)
        seconds = (seconds + 1) % 60
        
        //print(timerLabel.text!)
        
        if(seconds == 0){
            minutes = (minutes + 1) % 60
            if(minutes == 0){
                hours = (hours + 1) % 24
                if(hours == 0){
                    days += 1
                }
            }
        }
    }
    
}

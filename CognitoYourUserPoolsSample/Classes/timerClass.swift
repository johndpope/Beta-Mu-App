//
//  timerClass.swift
//  BetaMuScholarship
//
//  Created by James Weber on 1/4/18.
//  Copyright © 2018 Dubal, Rohan. All rights reserved.
//

import Foundation

class timerClass: NSObject {
    
    private var _startTime:[Int] = []
    private var _studying:Bool = Bool()
    private var _timerHasStarted:Bool = Bool()
    
    
    override init() {}
    
    required init(coder decoder: NSCoder) {
        <#statements#>
    }
    
    func encode(with coder: NSCoder) {
        
    }
    
    var startTime:[Int] {
        get {
            return _startTime
        }
        set {
            _startTime = newValue
        }
    }
    
    var studying: Bool {
        get {
            return _studying
        }
        set {
            _studying = newValue
        }
    }
    
    var timerHasStarted: Bool {
        get {
            return _timerHasStarted
        }
        set {
            _timerHasStarted = newValue
        }
    }
    
    
}

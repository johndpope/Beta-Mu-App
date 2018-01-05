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
    
    struct Keys {
        static let StartTime = "startTime"
        static let Studying = "studying"
        static let TimerHasStarted = "timerHasStarted"
    }
    
    override init() {}
    
    init(startTime: [Int], studying: Bool, timerHasStarted: Bool) {
        self._startTime = startTime
        self._studying = studying
        self._timerHasStarted = timerHasStarted
    }
    
    required init(coder decoder: NSCoder) {
        if let startTimeObj = decoder.decodeObject(forKey: Keys.StartTime) as? [Int] {
            _startTime = startTimeObj
        }
        if let studyingObj = decoder.decodeObject(forKey: Keys.Studying) as? Bool {
            _studying = studyingObj
        }
        if let timerHasStartedObj = decoder.decodeObject(forKey: Keys.TimerHasStarted) as? Bool {
            _timerHasStarted = timerHasStartedObj
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_startTime, forKey: Keys.StartTime)
        coder.encode(_studying, forKey: Keys.Studying)
        coder.encode(_timerHasStarted, forKey: Keys.TimerHasStarted)
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

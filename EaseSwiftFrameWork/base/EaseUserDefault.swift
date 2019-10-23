//
//  EaseUserDefault.swift
//  EaseSwiftFrameWork
//
//  Created by skynet on 2019/7/23.
//  Copyright © 2019 gmzb. All rights reserved.
//

import Foundation

let EaseUserDefault = UserDefaults.init(suiteName: "com.ease")!

#if DEBUG
let EaseUserDefaultsKey = "com.ease.userdefaults.test."
#else
let EaseUserDefaultsKey = "com.ease.userdefaults."
#endif


public extension UserDefaults {

    
    func add(_ boolValue: Bool, for key: String?) {
        
        guard let key = key else { return }
        let newKey = EaseUserDefaultsKey + key
        self.set(boolValue, forKey: newKey)
    }
    func boolValue(for key: String?) -> Bool {
        guard let key = key else { return false }
        let newKey = EaseUserDefaultsKey + key
        return (self.value(forKey: newKey) != nil)
    }
    
    func add(_ intValue: Int, for key: String?) {
        guard let key = key else { return }
        let newKey = EaseUserDefaultsKey + key
        self.set(intValue, forKey: newKey)
    }
    func intValue(for key: String?) -> Int {
        guard let key = key else { return 0 }
        let newKey = EaseUserDefaultsKey + key
        return self.value(forKey: newKey) as! Int
    }
    
    func add(_ stringValue: String, for key: String?) {
        guard let key = key else { return }
        let newKey = EaseUserDefaultsKey + key
        self.set(stringValue, forKey: newKey)
    }
    func stringValue(for key: String?) -> String {
        guard let key = key else { return "" }
        let newKey = EaseUserDefaultsKey + key
        if let value = self.value(forKey: newKey) {
            return value as! String
        }
        return ""
    }
}

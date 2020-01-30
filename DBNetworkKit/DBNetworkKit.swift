//
//  DBNetworkKit.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 28/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBLoggingKit

struct DBNetworkKit {
    static public let refreshTokenKey : String = "db.new.rt"
    static public let authTokenKey : String = "db.new.at"
    static public let envKey : String = "db.new.env"
    static public let uidKey : String = "db.new.uid"
    
    static var infoPlistValues : [String : Any]? {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                return NSDictionary(contentsOfFile: path) as? Dictionary<String , Any>
            } else {
                return nil
            }
            
        }
    }
    
    enum Env : Int {
        case None
        case Staging
        case Prod
    }
    
    static var currentEnv : Env {
        get {
            if let userDefaults = groupUserDefaults {
                return Env(rawValue:userDefaults.integer(forKey: envKey)) ?? .Prod
            } else {
                return .Prod
            }
        }
        set {
            groupUserDefaults?.set(newValue.rawValue, forKey: envKey)
        }
    }
    
    static var refreshToken : String? {
        get {
            return groupUserDefaults?.string(forKey: refreshTokenKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: refreshTokenKey)
        }
    }
    
    static var authToken : String? {
        get {
            return groupUserDefaults?.string(forKey: authTokenKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: authTokenKey)
        }
    }
    
    static var uid : String? {
        get {
            return groupUserDefaults?.string(forKey: uidKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: uidKey)
        }
    }
    
    static var groupBundleIdentifier : String {
        get {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                return "group.\(bundleIdentifier)"
            }
            return ""
        }
    }
    
    static var groupUserDefaults : UserDefaults? {
        get {
            return UserDefaults(suiteName: groupBundleIdentifier)
        }
    }
}

//
//  DBNetworkKit.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 28/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBLoggingKit
public struct DBNetworkKit {
    static let defaultAppEnvironment = Env.prod
    
    public enum FeedCursorDirection : String {
        case up = "up"
        case down = "down"
    }
    
    static public let refreshTokenKey : String = "rt"
    static public let authTokenKey : String = "at"
    static public let envKey : String = "env"
    static public let uidKey : String = "uid"
    
    static public let fcmToken = "fcmToken"
    
    static public let refreshTokenUserDefaultsKey : String = "db.new.rt"
    static public let authTokenserDefaultsKey : String = "db.new.at"
    static public let envserDefaultsKey : String = "db.new.env"
    static public let uidserDefaultsKey : String = "db.new.uid"
    static public let appEnvDefaultsKey : String = "db.new.app.environment"
    
    static var infoPlistValues : [String : Any]? {
        get {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                return NSDictionary(contentsOfFile: path) as? Dictionary<String , Any>
            } else {
                return nil
            }
        }
    }
    
    enum Env : String {
        case staging
        case prod
    }
    
    static var environment : Env {
        get {
            if let userDefaultsValue = groupUserDefaults?.string(forKey: appEnvDefaultsKey), let userDefaultsEnv = Env(rawValue: userDefaultsValue) {
                return userDefaultsEnv
            } else {
                return DBNetworkKit.defaultAppEnvironment
            }
        }
        set {
            groupUserDefaults?.set(newValue.rawValue, forKey: envserDefaultsKey)
        }
    }
    
    static var refreshToken : String? {
        get {
            return groupUserDefaults?.string(forKey: refreshTokenUserDefaultsKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: refreshTokenUserDefaultsKey)
        }
    }
    
    static var authToken : String? {
        get {
            return groupUserDefaults?.string(forKey: authTokenserDefaultsKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: authTokenserDefaultsKey)
        }
    }
    
    static var uid : Int? {
        get {
            return groupUserDefaults?.integer(forKey: uidserDefaultsKey)
        }
        
        set {
            guard let token = newValue else {
                return
            }
            UserDefaults(suiteName: groupBundleIdentifier)?.setValue(token, forKey: uidserDefaultsKey)
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
    
    public static var groupUserDefaults : UserDefaults? {
        get {
            return UserDefaults(suiteName: groupBundleIdentifier)
        }
    }
}

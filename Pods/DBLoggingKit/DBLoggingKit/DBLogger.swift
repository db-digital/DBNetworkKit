//
//  DBLogger.swift
//  DBLoggingKit
//
//  Created by Rajat Agrawal on 15/01/20.
//  Copyright © 2020 Rajat Agrawal. All rights reserved.
//

import UIKit
import CocoaLumberjack

public enum DBLogLevel {
    case verbose
    case info
    case warn
    case error
}

public class DBLogger: NSObject {
    public static let shared = DBLogger()
    static let shouldLogMessageUserDefaultKey = "shouldLogMessage"

    private var _shouldLogMessage : Bool = UserDefaults.standard.bool(forKey: DBLogger.shouldLogMessageUserDefaultKey)
    public var shouldLogMessage : Bool {
        get {
            return _shouldLogMessage
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DBLogger.shouldLogMessageUserDefaultKey)
            _shouldLogMessage = newValue
        }
    }
    
    override public init() {
        super.init()
        
        // Add OS Logger
        DDLog.add(DDOSLogger.sharedInstance)
        
        // Add Default file logger
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    func logFileData() {
//        do {
//            let url = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let logFileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//        } catch let error {
//            self.logMessage(message: "There was an error retrieving logs directory \(error)", level: .error)
//        }
    }
    
    public func logMessage(message : String, level : DBLogLevel = .info, tag : String = "") {
        #if DEBUG
        var taggedMessage = message
        if tag.count > 0 {
            taggedMessage = "\(tag) : \(taggedMessage)"
        }
        
        switch level {
        case .info:
            DDLogInfo(taggedMessage)
            break
        case .error:
            DDLogError(taggedMessage)
            break
        case .verbose:
            DDLogVerbose(taggedMessage)
            break
        case .warn:
            DDLogWarn(taggedMessage)
            break
        }
        #endif
    }
}

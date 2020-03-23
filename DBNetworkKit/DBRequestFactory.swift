//
//  DBRequest.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 28/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit

public class DBRequestFactory {
    static private let channelIdKey = "ChannelId"
    static private let versionKey = "CFBundleShortVersionString"
    static private let buildKey = "CFBundleVersion"
    
    static func baseURLComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = DBNetworkKeys.scheme
        urlComponents.host = DBNetworkKeys.baseHostName
        urlComponents.path = DBNetworkKeys.basePath
        urlComponents.queryItems = []
        return urlComponents
    }
    
    static func baseURLRequest(url : URL) -> URLRequest {
        var request = accessTokenRequest(url: url)
        if let at = DBNetworkKit.authToken {
            request.setValue(at, forHTTPHeaderField: "at")
        }
        return request
    }
    
    static func accessTokenRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("ios", forHTTPHeaderField: "dtyp")
        request.setValue(channelId, forHTTPHeaderField: "cid")
        request.setValue("a6oaq3edtz59", forHTTPHeaderField: "x-aut-t")
        request.setValue(version, forHTTPHeaderField: "a-ver-name")
        request.setValue(build, forHTTPHeaderField: "a-ver-code")
        return request
    }
    
    static var channelId: String {
        get {
            if let plistData = DBNetworkKit.infoPlistValues {
                return plistData[channelIdKey] as? String ?? "0"
            }
            return "0"
        }
    }
    
    static var version: String {
        get {
            if let plistData = DBNetworkKit.infoPlistValues {
                return plistData[versionKey] as? String ?? "0"
            }
            return "0"
        }
    }
    
    static var build: String {
        get {
            if let plistData = DBNetworkKit.infoPlistValues {
                return plistData[buildKey] as? String ?? "0"
            }
            return "0"
        }
    }
}

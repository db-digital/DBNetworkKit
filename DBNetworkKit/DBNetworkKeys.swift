//
//  DBNetworkKeys.swift
//  DBNetworkKit
//
//  Created by Amit Singh on 06/02/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit

struct DBNetworkKeys {
    static var hostName : String {
        get {
            if DBNetworkKit.environment == .staging {
                return "staging"
            } else {
                return "prod"
            }
        }
    }
    static public let scheme = "https"
    static public let baseHostName = "\(hostName).bhaskarapi.com"
    static public let basePath = "/api/1.0"
    static public let cities = "/cities"
    static public let userCities = "/user/prefs/cities"
    static public let updateFcmToken = "/user/update-fcm-token"
    static public let refreshAuthToken = "/user/at"
    static public let registerAuthToken = "/user/register"
    static public let sendOTP = "/user/signup"
    static public let verifyOTP = "/user/verify-otp"
    static public let feedHome = "/feed/home"
    static public let story = "/feed/story/"
    static public let categories = "/cats"
    static public let feedCategory = "/feed/category/"
    static public let searchList = "/cats/all"
    static public let editionList = "/epaper/editions/list"
    static public let editionPages = "/epaper/edition/"
    static public let magazineList = "/epaper/mag/editions/list"
    static public let epaperDetails = "/epaper/edition/"
    static public let magazineDetails = "/epaper/mag/edition/"
    static public let epaperCities = "/epaper/cities/list"
    static public let epaperUserCities = "/epaper/user/cities/list"
    static public let saveEpaperUserCities = "/epaper/user/cities"
    static public let videofeed = "/feed/video/home"
    static public let deeplinkJson = "/modify-share-url"
}


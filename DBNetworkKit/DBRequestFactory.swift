//
//  DBRequest.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 28/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit

public class DBRequestFactory {
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
        request.setValue("521", forHTTPHeaderField: "cid")
        request.setValue("a6oaq3edtz59", forHTTPHeaderField: "x-aut-t")
        request.setValue("hehheh", forHTTPHeaderField: "a-ver-name")
        request.setValue("1234", forHTTPHeaderField: "a-ver-code")
        return request
    }
}

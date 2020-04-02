//
//  DBAuthenticator.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 02/04/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBLoggingKit

class DBAuthenticator {
    static let shared = DBAuthenticator()
    let queue = DispatchQueue(label: "\(DBNetworkKit.groupBundleIdentifier).authenticator")
    var beingRefreshed = false
    
    func authenticate(completion: ((Bool)->())?) {
        queue.async {
            if let _ = DBNetworkKit.authToken {
                completion?(true)
            } else {
                var urlComponents = DBRequestFactory.baseURLComponents()
                urlComponents.path.append(contentsOf: DBNetworkKeys.registerAuthToken)
                if let url = urlComponents.url {
                    var request = DBRequestFactory.accessTokenRequest(url: url)
                    request.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
                    
                    let dataTask = URLSession.shared.dataTask(with: request) {
                        data, urlResponse, error in
                        let result = DBNetworkManager.getResponseFromData(data: data)
                        DBLogger.shared.logMessage(message: "Result for authentication is \(result), response \(String(describing: urlResponse)), error \(String(describing: error))")
                        if let result = result.responseData  {
                            if let at = result[DBNetworkKit.authTokenKey] as? String {
                                DBNetworkKit.authToken = at
                            } else {
                                DBLogger.shared.logMessage(message: "corrupted auth token received")
                                completion?(false)
                                return
                            }
                            
                            if let rt = result[DBNetworkKit.refreshTokenKey] as? String {
                                DBNetworkKit.refreshToken = rt
                            } else {
                                DBLogger.shared.logMessage(message: "corrupted refresh token received")
                                completion?(false)
                                return
                            }
                            
                            if let uid = result[DBNetworkKit.uidKey] as? Int {
                                DBNetworkKit.uid = uid
                            } else {
                                DBLogger.shared.logMessage(message: "corrupted uid token received")
                                completion?(false)
                                return
                            }
                            
                            DBLogger.shared.logMessage(message: "Authentication successfull")
                            completion?(true)
                        } else {
                            DBLogger.shared.logMessage(message: "corrupted data in authentication response")
                            completion?(false)
                        }
                    }
                    dataTask.resume()
                } else {
                    DBLogger.shared.logMessage(message: "Unable to get url for authentication")
                    completion?(false)
                }
            }
        }
    }
    
    public func refreshAuthToken(completion: ((Bool)->())?) {
        objc_sync_enter(self)
        if beingRefreshed {
            completion?(true)
        } else {
            beingRefreshed = true
            queue.async {
                var urlComponents = DBRequestFactory.baseURLComponents()
                urlComponents.path.append(contentsOf: DBNetworkKeys.refreshAuthToken)
                if let url = urlComponents.url {
                    var request = DBRequestFactory.accessTokenRequest(url: url)
                    request.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
                    let body = [ DBNetworkKit.authTokenKey : DBNetworkKit.authToken,
                                 DBNetworkKit.refreshTokenKey : DBNetworkKit.refreshToken,
                                 DBNetworkKit.uidKey : String(describing: DBNetworkKit.uid)
                    ]
                    let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                    request.httpBody = jsonData
                    
                    let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                        if let self = self {
                            if let _ = error {
                                self.beingRefreshed = false
                                completion?(false)
                            } else {
                                // 403
                                if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 403 {
                                    // save blocked user value
                                    let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                    self.beingRefreshed = false
                                    completion?(false)
                                } else {
                                    // save auth token and refresh token
                                    if let responseJSON = DBNetworkManager.getResponseFromData(data: data).responseData  {
                                        if let at = responseJSON[DBNetworkKit.authTokenKey] as? String,
                                            let rt = responseJSON[DBNetworkKit.refreshTokenKey] as? String {
                                            DBNetworkKit.authToken = at
                                            DBNetworkKit.refreshToken = rt
                                            self.beingRefreshed = false
                                            completion?(true)
                                        } else {
                                            let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                            self.beingRefreshed = false
                                            completion?(false)
                                        }
                                    } else {
                                        let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                        self.beingRefreshed = false
                                        completion?(false)
                                    }
                                }
                            }
                        } else {
                            self?.beingRefreshed = false
                            completion?(false)
                        }
                    }
                    dataTask.resume()
                } else {
                    // Add error here later
                    let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                    self.beingRefreshed = false
                    completion?(false)
                }
            }
        }
        objc_sync_exit(self)
    }
    
    func authToken(completion: ((String?)->())?) {
        queue.async {
            completion?(DBNetworkKit.authToken)
        }
    }
    
    func refreshToken(completion: ((String?)->())?) {
        queue.async {
            completion?(DBNetworkKit.refreshToken)
        }
    }
    
    func uid(completion: ((Int?)->())?) {
        queue.async {
            completion?(DBNetworkKit.uid)
        }
    }
}

//
//  DBAuthenticator.swift
//  DBNetworkKit
//
//  Created by Rajat Agrawal on 02/04/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBLoggingKit

public class DBAuthenticator {
    public static let shared = DBAuthenticator()
    let queue = DispatchQueue(label: "\(DBNetworkKit.groupBundleIdentifier).authenticator")
    var beingRefreshed = false
    let semaphore = DispatchSemaphore(value: 1)
    
    public func authenticate(completion: ((Bool)->())?) {
        self.queue.async { [weak self] in
            if let self = self {
                self.semaphore.wait()
                DBLogger.shared.logMessage(message: "Current Uid token during authentication is \(String(describing: DBNetworkKit.uid))", level: .info, tag: "DBNetworkKit")
                if let uid = DBNetworkKit.uid, uid != 0 {
                    self.semaphore.signal()
                    DBLogger.shared.logMessage(message: "UID token already present. Authentication Successful \(String(describing: DBNetworkKit.uid))", level: .info, tag: "DBNetworkKit")
                    completion?(true)
                } else {
                    var urlComponents = DBRequestFactory.baseURLComponents()
                    urlComponents.path.append(contentsOf: DBNetworkKeys.registerAuthToken)
                    if let url = urlComponents.url {
                        var request = DBRequestFactory.accessTokenRequest(url: url)
                        request.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
                        let dataTask = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                            let result = DBNetworkManager.getResponseFromData(data: data)
                            DBLogger.shared.logMessage(message: "Result for authentication is \(result), response \(String(describing: urlResponse)), error \(String(describing: error))")
                            if let result = result.responseData  {
                                if let at = result[DBNetworkKit.authTokenKey] as? String {
                                    DBNetworkKit.authToken = at
                                    DBLogger.shared.logMessage(message: "Auth response Auth token \(at)", level: .info, tag: "DBNetworkKit")
                                } else {
                                    DBLogger.shared.logMessage(message: "corrupted auth token received", level: .info, tag: "DBNetworkKit")
                                    self.semaphore.signal()
                                    completion?(false)
                                    return
                                }
                                
                                if let rt = result[DBNetworkKit.refreshTokenKey] as? String {
                                    DBNetworkKit.refreshToken = rt
                                    DBLogger.shared.logMessage(message: "Auth response Refresh token \(rt)", level: .info, tag: "DBNetworkKit")
                                } else {
                                    DBLogger.shared.logMessage(message: "corrupted refresh token received", level: .info, tag: "DBNetworkKit")
                                    self.semaphore.signal()
                                    completion?(false)
                                    return
                                }
                                
                                if let uid = result[DBNetworkKit.uidKey] as? Int {
                                    DBNetworkKit.uid = uid
                                    DBLogger.shared.logMessage(message: "Auth response UID \(uid)", level: .info, tag: "DBNetworkKit")
                                } else {
                                    DBLogger.shared.logMessage(message: "corrupted uid token received", level: .info, tag: "DBNetworkKit")
                                    self.semaphore.signal()
                                    completion?(false)
                                    return
                                }
                                DBLogger.shared.logMessage(message: "Authentication successfullllllll", level: .info, tag: "DBNetworkKit")
                                self.semaphore.signal()
                                completion?(true)
                            } else {
                                DBLogger.shared.logMessage(message: "corrupted data in authentication response", level: .info, tag: "DBNetworkKit")
                                self.semaphore.signal()
                                completion?(false)
                            }
                        }
                        dataTask.resume()
                    } else {
                        DBLogger.shared.logMessage(message: "Unable to get url for authentication", level: .info, tag: "DBNetworkKit")
                        self.semaphore.signal()
                        completion?(false)
                    }
                }
            } else {
                completion?(false)
            }
        }
    }
    
    public func refreshAuthToken(completion: ((Bool)->())?) {
        queue.async { [weak self] in
            if let self = self {
                self.semaphore.wait()
                if self.beingRefreshed {
                    DBLogger.shared.logMessage(message: "Being refreshed. Returning", level: .info, tag: "DBNetworkKit.Refresh")
                    self.semaphore.signal()
                    completion?(true)
                } else {
                    DBLogger.shared.logMessage(message: "Going to refresh", level: .info, tag: "DBNetworkKit.Refresh")
                    self.beingRefreshed = true
                    var urlComponents = DBRequestFactory.baseURLComponents()
                    urlComponents.path.append(contentsOf: DBNetworkKeys.refreshAuthToken)
                    if let url = urlComponents.url {
                        var request = DBRequestFactory.accessTokenRequest(url: url)
                        request.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
                        let body : [String : Any?] = [ DBNetworkKit.authTokenKey : DBNetworkKit.authToken,
                                     DBNetworkKit.refreshTokenKey : DBNetworkKit.refreshToken,
                                     DBNetworkKit.uidKey : DBNetworkKit.uid
                            ]
                        DBLogger.shared.logMessage(message: "Refresh token request \(body)", level: .info, tag: "DBNetworkKit")
                        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                        request.httpBody = jsonData
                        
                        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                            if let self = self {
                                if let _ = error {
                                    self.beingRefreshed = false
                                    DBLogger.shared.logMessage(message: "Unsuccessful refresh 1", level: .info, tag: "DBNetworkKit.Refresh")
                                    self.semaphore.signal()
                                    completion?(false)
                                } else {
                                    // 403
                                    if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 403 {
                                        // save blocked user value
                                        let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                        self.beingRefreshed = false
                                        DBLogger.shared.logMessage(message: "Unsuccessful refresh 2", level: .info, tag: "DBNetworkKit.Refresh")
                                        self.semaphore.signal()
                                        completion?(false)
                                    } else {
                                        // save auth token and refresh token
                                        if let responseJSON = DBNetworkManager.getResponseFromData(data: data).responseData  {
                                            if let at = responseJSON[DBNetworkKit.authTokenKey] as? String,
                                                let rt = responseJSON[DBNetworkKit.refreshTokenKey] as? String {
                                                DBNetworkKit.authToken = at
                                                DBNetworkKit.refreshToken = rt
                                                
                                                DBLogger.shared.logMessage(message: "Refresh call : Auth token Response : \(at)", level: .info, tag: "DBNetworkKit")
                                                DBLogger.shared.logMessage(message: "Refresh call : Refresh token Response : \(rt)", level: .info, tag: "DBNetworkKit")
                                                self.beingRefreshed = false
                                                DBLogger.shared.logMessage(message: "Successful refresh", level: .info, tag: "DBNetworkKit.Refresh")
                                                self.semaphore.signal()
                                                completion?(true)
                                            } else {
                                                let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                                self.beingRefreshed = false
                                                DBLogger.shared.logMessage(message: "Unsuccessful refresh 3 \(responseJSON)", level: .info, tag: "DBNetworkKit.Refresh")
                                                self.semaphore.signal()
                                                completion?(false)
                                            }
                                        } else {
                                            let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                                            self.beingRefreshed = false
                                            DBLogger.shared.logMessage(message: "Unsuccessful refresh 4", level: .info, tag: "DBNetworkKit.Refresh")
                                            self.semaphore.signal()
                                            completion?(false)
                                        }
                                    }
                                }
                            } else {
                                self?.beingRefreshed = false
                                DBLogger.shared.logMessage(message: "Unsuccessful refresh 5", level: .info, tag: "DBNetworkKit.Refresh")
                                self?.semaphore.signal()
                                completion?(false)
                            }
                        }
                        dataTask.resume()
                    } else {
                        // Add error here later
                        let _ = NSError(domain: "DBNetworkKit", code: 0, userInfo: nil)
                        self.beingRefreshed = false
                        DBLogger.shared.logMessage(message: "Unsuccessful refresh 6", level: .info, tag: "DBNetworkKit.Refresh")
                        self.semaphore.signal()
                        completion?(false)
                    }
                }
            } else {
                // self not present
                DBLogger.shared.logMessage(message: "Unsuccessful refresh 7", level: .info, tag: "DBNetworkKit.Refresh")
                completion?(false)
            }
        }
    }
    
    public func authToken(completion: ((String?)->())?) {
        queue.async {
            completion?(DBNetworkKit.authToken)
        }
    }
    
    public func refreshTokenValue(completion: ((String?)->())?) {
        queue.async {
            completion?(DBNetworkKit.refreshToken)
        }
    }
    
    public func uid(completion: ((Int?)->())?) {
        queue.async {
            completion?(DBNetworkKit.uid)
        }
    }
    
    public func resetLoginDetails(completion: (()->())?) {
        queue.async {
            DBNetworkKit.authToken = ""
            DBNetworkKit.refreshToken = ""
            DBNetworkKit.uid = 0
            completion?()
        }
    }
}

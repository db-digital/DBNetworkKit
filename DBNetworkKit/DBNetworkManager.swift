//
//  DBNetworkManager.swift
//  DBNetworkKit
//
//  Created by Nitin A on 15/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import Foundation
import DBLoggingKit

public class DBNetworkManager {
    
    // MARK: - Public Methods
    public static let shared: DBNetworkManager = DBNetworkManager()
    
    public func getCityListWithCompletion(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/cities") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func saveCityListWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/user/prefs/cities") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getSavedCityListWithCompletion(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/user/prefs/cities") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func updateFcmTokenWithCompletion(parameters: [String: Any], completion : ((String, [AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/update-fcm-token") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest) { (response, data, error) in
                let fcmToken = parameters[DBNetworkKit.fcmToken] as? String ?? ""
                completion?(fcmToken, response, data, error)
            }
        } else {
            completion?("", nil, nil, nil)
        }
    }
    
    public func executeURLRequest(urlRequest : URLRequest, completion : (([AnyHashable : Any]?, Data?, Error?)->())?) {
               
        if let authToken = DBNetworkKit.authToken, authToken.count > 0 {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                if let self = self {
                    
                    if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 401 {
                        self.refreshAuthToken { (refreshTokenError) -> () in
                            if (refreshTokenError != nil) {
                                // re-rerun the request
                                let dataTaskRetry = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                                    if let deserializedResponse = self.getResponseFromData(data: data).responseData  {
                                        completion?(deserializedResponse, data ,error)
                                    } else {
                                        completion?(nil, nil, error)
                                    }
                                }
                                dataTaskRetry.resume()
                            } else {
                                completion?(nil, nil, refreshTokenError)
                            }
                        }
                    } else {
                        if let deserializedResponse = self.getResponseFromData(data: data).responseData  {
                            completion?(deserializedResponse, data, error)
                        } else {
                            completion?(nil, nil, error)
                        }
                    }
                } else {
                    completion?(nil, nil, error)
                }
            }
            dataTask.resume()
        } else {
            authenticateWithCompletion { [weak self] (response, authenticationError) in
                if let self = self {
                    
                    if authenticationError != nil  {
                        completion?(nil, nil, authenticationError)
                    } else {
                        self.executeURLRequest(urlRequest: urlRequest, completion: completion)
                    }
                } else {
                    completion?(nil, nil, NSError())
                }
            }
        }
    }
    
    public func refreshAuthToken(completion: ((Error?)->())?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/user/at") {
            var request = DBRequestFactory.accessTokenRequest(url: url)
            request.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            let body = [ DBNetworkKit.authTokenKey : DBNetworkKit.authToken,
                         DBNetworkKit.refreshTokenKey : DBNetworkKit.refreshToken,
                         DBNetworkKit.uidKey : String(describing: DBNetworkKit.uid)
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            request.httpBody = jsonData
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                if let error = error {
                    completion?(error)
                } else {
                    // 403
                    if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 403 {
                        // save blocked user value
                        completion?(NSError(domain: "DBNetworkKit", code: 0, userInfo: nil))
                    } else {
                        // save auth token and refresh token
                        if let self = self, let responseJSON = self.getResponseFromData(data: data).responseData  {
                            if let at = responseJSON[DBNetworkKit.authTokenKey] as? String,
                                let rt = responseJSON[DBNetworkKit.refreshTokenKey] as? String {
                                DBNetworkKit.authToken = at
                                DBNetworkKit.refreshToken = rt
                                completion?(nil)
                            } else {
                                completion?(NSError(domain: "DBNetworkKit", code: 0, userInfo: nil))
                            }
                        } else {
                            completion?(NSError(domain: "DBNetworkKit", code: 0, userInfo: nil))
                        }
                    }
                }
            }
            dataTask.resume()
        } else {
            // Add error here later
            completion?(NSError(domain: "DBNetworkKit", code: 0, userInfo: nil))
        }
        
    }
    public func authenticateWithCompletion(completion: (([AnyHashable : Any]?, Error?)->())?) {
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/user/register") {
            var request = DBRequestFactory.accessTokenRequest(url: url)
            request.httpMethod = RequestMethod.post.rawValue
            
            let dataTask = URLSession.shared.dataTask(with: request) {
                data, response, error in
                let result = self.getResponseFromData(data: data)
                
                if let result = result.responseData  {
                    if let at = result[DBNetworkKit.authTokenKey] as? String {
                        DBNetworkKit.authToken = at
                    }
                    
                    if let rt = result[DBNetworkKit.refreshTokenKey] as? String {
                        DBNetworkKit.refreshToken = rt
                    }
                    
                    if let uid = result[DBNetworkKit.uidKey] as? Int {
                        DBNetworkKit.uid = uid
                    }
                }
                
                DBLogger.shared.logMessage(message: "Response for authentication is \(response)")
                completion?(result.responseData, error)
            }
            dataTask.resume()
            
        }
        
    }
    
    public func startNetworkMonitor() {
        DBLogger.shared.logMessage(message: "Network monitoring start....")
    }
    
    fileprivate func convertToData(_ value: Any) -> Data {
        if let str =  value as? String {
            return str.data(using: String.Encoding.utf8)!
        } else if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
            return jsonData
        } else {
            return Data()
        }
    }
    
    // MARK:- Private Method
    private func printableParams(dictionary: Dictionary<String, Any>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let theJSONText = String(data: jsonData, encoding: .ascii)
            return theJSONText ?? ""
        } catch {
            return ""
        }
    }
    
    private func getResponseFromData(data: Data?) -> (responseData: [AnyHashable : Any]?, error: Error?) {
        guard let data = data else { return (nil, nil) }
        do {
            let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable : Any]
            return (responseData, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    func timeStamp()-> TimeInterval {
        return Date().timeIntervalSince1970.rounded()
    }
}

extension DBNetworkManager {
    public enum RequestMethod : String {
        case get = "GET"
        case post = "POST"
    }
}

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
    
    public func saveUserAgeWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func saveUserGenderWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func saveUsernameWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func verifyOTPWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.verifyOTP)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    
    public func sendOTPWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.sendOTP)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func executeNonDBURLRequest(url : URL, completion : (([AnyHashable : Any]?, Data?, Error?)->())?) {
        var urlRequest = DBRequestFactory.baseURLRequest(url: url)
        urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            if let self = self {
                if let deserializedResponse = self.getResponseFromData(data: data).responseData  {
                    completion?(deserializedResponse, data, error)
                } else {
                    completion?(nil, data, error)
                }
            }
        }
        task.resume()
    }
    
    public func getCityListWithCompletion(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.cities)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func saveCityListWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.userCities)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getSavedCityListWithCompletion(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.userCities) 
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func updateFcmTokenWithCompletion(parameters: [String: Any], completion : ((String, [AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.updateFcmToken)
        
        if let url = urlComponents.url {
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
    
    public func getArticleWithIdentifier(identifier : Int, completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.story + "\(identifier)")
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getFeed(cursorID : String?, categoryId: Int?, direction: DBNetworkKit.FeedCursorDirection?, completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        
        if let categoryID = categoryId {
            urlComponents.path.append(contentsOf: DBNetworkKeys.feedCategory + "\(categoryID)")
        } else {
            urlComponents.path.append(contentsOf: DBNetworkKeys.feedHome)
        }
        
        if let cursorID = cursorID, cursorID.count > 0 {
            urlComponents.queryItems?.append(URLQueryItem(name: "cursor", value: cursorID))
        }
        
        if let direction = direction {
            urlComponents.queryItems?.append(URLQueryItem(name: "direction", value: direction.rawValue))
        }
        
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getSearchListWithCompletion(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.searchList)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
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
            authenticateWithCompletion { [weak self] (urlResponse, response, authenticationError) in
                if let self = self {
                    if let urlResponse = urlResponse, urlResponse.statusCode != 200 {
                        completion?(nil, nil, authenticationError)
                    } else if authenticationError != nil  {
                        completion?(nil, nil, authenticationError)
                    } else {
                        var authenticatedURLRequest = urlRequest
                        authenticatedURLRequest.reloadAuthenticationHeader()
                        self.executeURLRequest(urlRequest: authenticatedURLRequest, completion: completion)
                    }
                } else {
                    completion?(nil, nil, NSError())
                }
            }
        }
    }
    
    public func refreshAuthToken(completion: ((Error?)->())?) {
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
  
    public func authenticateWithCompletion(completion: ((HTTPURLResponse?, [AnyHashable : Any]?, Error?)->())?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.registerAuthToken)
        if let url = urlComponents.url {
            var request = DBRequestFactory.accessTokenRequest(url: url)
            request.httpMethod = RequestMethod.post.rawValue
            
            let dataTask = URLSession.shared.dataTask(with: request) {
                data, urlResponse, error in
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
                
                DBLogger.shared.logMessage(message: "Response for authentication is \(urlResponse)")
                completion?(urlResponse as? HTTPURLResponse, result.responseData, error)
            }
            dataTask.resume()
            
        }
        
    }
    
    public func sendRequest(urlString: String,
                            method: DBNetworkManager.RequestMethod,
                            parameters: [String: Any]?,
                            completion: @escaping (_ data: Data?, _ error: Error?) -> ()) -> Void {
        
        DBLogger.shared.logMessage(message: "Connecting with URL \(urlString) with parameters: \(String(describing: parameters))")
        guard let url = URL(string: urlString) else { return }
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            let result = self.getResponseFromData(data: data)
            DBLogger.shared.logMessage(message: "Response for URL \(urlString) is: \(result)")
            completion(data, error)
        }
        dataTask.resume()
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
            DBLogger.shared.logMessage(message: "Error during parsing data is \(error)")
            return (nil, error)
        }
    }
    
    func timeStamp()-> TimeInterval {
        return Date().timeIntervalSince1970.rounded()
    }
    
    public func getCategories(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.categories)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getEpaperEditionList(completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.editionList)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
}

extension DBNetworkManager {
    public enum RequestMethod : String {
        case get = "GET"
        case post = "POST"
    }
}

extension URLRequest {
    mutating func reloadAuthenticationHeader() {
        if let at = DBNetworkKit.authToken {
            self.setValue(at, forHTTPHeaderField: "at")
        }
    }
}


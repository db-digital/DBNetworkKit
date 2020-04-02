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
    public var authCompletion: ((Int?) -> ())?
    
    init() {
        DBAuthenticator.shared.authenticate(completion: nil)
        DBAuthenticator.shared.refreshAuthToken(completion: nil)
        DBAuthenticator.shared.authenticate(completion: nil)
//        DBAuthenticator.shared.refreshAuthToken(completion: nil)
//        DBAuthenticator.shared.refreshAuthToken(completion: nil)
//        DBAuthenticator.shared.refreshAuthToken(completion: nil)
    }
    
    public func saveUserAgeWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
//        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
//            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
//            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
//            executeURLRequest(urlRequest: urlRequest, completion: completion)
//        } else {
//            completion?(nil, nil, nil)
//        }
    }
    
    public func saveUserGenderWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
//        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
//            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
//            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
//            executeURLRequest(urlRequest: urlRequest, completion: completion)
//        } else {
//            completion?(nil, nil, nil)
//        }
    }
    
    public func saveUsernameWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
//        if let url = URL(string: "https://api.myjson.com/bins/hfgxs") {
//            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
//            //urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
//            executeURLRequest(urlRequest: urlRequest, completion: completion)
//        } else {
//            completion?(nil, nil, nil)
//        }
    }
    
    public func verifyOTPWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
//        var urlComponents = DBRequestFactory.baseURLComponents()
//        urlComponents.path.append(contentsOf: DBNetworkKeys.verifyOTP)
//
//        if let url = urlComponents.url {
//            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
//            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
//            executeURLRequest(urlRequest: urlRequest, completion: completion)
//        } else {
//            completion?(nil, nil, nil)
//        }
    }
    
    
    public func sendOTPWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
//        var urlComponents = DBRequestFactory.baseURLComponents()
//        urlComponents.path.append(contentsOf: DBNetworkKeys.sendOTP)
//
//        if let url = urlComponents.url {
//            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
//            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
//            executeURLRequest(urlRequest: urlRequest, completion: completion)
//        } else {
//            completion?(nil, nil, nil)
//        }
    }
    
    public func executeNonDBURLRequest(url : URL, completion : (([AnyHashable : Any]?, Data?, Error?)->())?) {
//        var urlRequest = DBRequestFactory.baseURLRequest(url: url)
//        urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
//        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let deserializedResponse = DBNetworkManager.getResponseFromData(data: data).responseData  {
//                completion?(deserializedResponse, data, error)
//            } else {
//                completion?(nil, data, error)
//            }
//        }
//        task.resume()
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
    
    public func getFeed(selectedCities:String?, cursorID : String?, feedID: Int?, direction: DBNetworkKit.FeedCursorDirection?, completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        
        if let feedID = feedID {
            urlComponents.path.append(contentsOf: DBNetworkKeys.feedCategory + "\(feedID)")
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
            if let cities = selectedCities {
                urlRequest.setValue(cities, forHTTPHeaderField: "cities")
            }
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
    
    public func getVideoFeedWithCompletion(selectedCities: String, completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.videofeed)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.setValue(selectedCities, forHTTPHeaderField: "cities")
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getJsonFromDeeplinkWithCompletion(parameters: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.deeplinkJson)
        
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
            executeURLRequest(urlRequest: urlRequest) { (response, data, error) in
                completion?(response, data, error)
            }
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func executeURLRequest(urlRequest : URLRequest, completion : (([AnyHashable : Any]?, Data?, Error?)->())?) {
        if let authToken = DBNetworkKit.authToken, authToken.count > 0 {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                if let self = self {
                    if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 401 {
                        DBAuthenticator.shared.refreshAuthToken { (success) in
                            if (success) {
                                var refreshedURLRequest = urlRequest
                                refreshedURLRequest.reloadAuthenticationHeader()
                                self.executeURLRequest(urlRequest: refreshedURLRequest, completion: completion)
                            } else {
                                let error = NSError(domain: "DBNetworkKit", code: 1, userInfo: nil)
                                completion?(nil, nil, error)
                            }
                        }
                    } else {
                        if let deserializedResponse = DBNetworkManager.getResponseFromData(data: data).responseData  {
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
            authenticateWithCompletion { (success) in
                if success {
                    var authenticatedURLRequest = urlRequest
                    authenticatedURLRequest.reloadAuthenticationHeader()
                    self.executeURLRequest(urlRequest: authenticatedURLRequest, completion: completion)
                } else {
                    completion?(nil, nil, NSError(domain: "dainik bhaskar", code: 1, userInfo: nil))
                }
            }
        }
    }
  
    public func authenticateWithCompletion(completion: ((Bool)->())?) {
        DBAuthenticator.shared.authenticate { [weak self] (success) in
            if success {
                DBAuthenticator.shared.uid { [weak self] (uid) in
                    if let self = self {
                        self.authCompletion?(uid)
                    }
                    completion?(success)
                }
            } else {
                completion?(success)
            }
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
            let result = DBNetworkManager.getResponseFromData(data: data)
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
    
    class func getResponseFromData(data: Data?) -> (responseData: [AnyHashable : Any]?, error: Error?) {
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
    
    public func getCategories(selectedCities: String, completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.categories)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            urlRequest.setValue(selectedCities, forHTTPHeaderField: "cities")
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getEpaperEditionList(isMagazine: Bool, completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: isMagazine ? DBNetworkKeys.magazineList : DBNetworkKeys.editionList)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getEpaperDetails(isMagazine: Bool, edCode: String, reqDate: String?, completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        let urlPath = isMagazine ? DBNetworkKeys.magazineDetails : DBNetworkKeys.epaperDetails
        urlComponents.path.append(contentsOf: urlPath + edCode)
        if let date = reqDate {
            urlComponents.queryItems?.append(URLQueryItem(name: "dt", value: date))
        }
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getEpaperCityList(isUserCity: Bool, completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: isUserCity ? DBNetworkKeys.epaperUserCities : DBNetworkKeys.epaperCities)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func saveEpaperUserCities(params: [String: Any], completion : (([AnyHashable : Any]?, Data?, Error?)->Void)?) {
        var urlComponents = DBRequestFactory.baseURLComponents()
        urlComponents.path.append(contentsOf: DBNetworkKeys.saveEpaperUserCities)
        if let url = urlComponents.url {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: params).data(using: .utf8)
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


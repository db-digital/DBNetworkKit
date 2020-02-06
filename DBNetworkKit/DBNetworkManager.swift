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
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/cities") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.post.rawValue
            urlRequest.httpBody = printableParams(dictionary: parameters).data(using: .utf8)
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
    
    public func getFeedWithCursorID(cursorID : String, completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        if let url = URL(string: "https://api.myjson.com/bins/17cw0m") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getArticleWithIdentifier(identifier : Int, completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        if let url = URL(string: "https://api.myjson.com/bins/j9v4q") {
            var urlRequest = DBRequestFactory.baseURLRequest(url: url)
            urlRequest.httpMethod = DBNetworkManager.RequestMethod.get.rawValue
            executeURLRequest(urlRequest: urlRequest, completion: completion)
        } else {
            completion?(nil, nil, nil)
        }
    }
    
    public func getFeed(completion: (([AnyHashable: Any]?, Data?, Error?)->())?) {
        if let url = URL(string: "https://api.myjson.com/bins/17cw0m") {
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
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/at") {
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
        if let url = URL(string: "http://prod.bhaskarapi.com/api/1.0/register") {
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
//        NetworkReachability.shared.startMonitoring()
    }
    
    public func sendRequest(urlString: String,
                            method: DBNetworkManager.RequestMethod,
                            parameters: [String: Any]?,
                            completion: @escaping (_ data: Data?, _ error: Error?) -> ()) -> Void {
        
        DBLogger.shared.logMessage(message: "Connecting with URL \(urlString) with parameters: \(String(describing: parameters))")
        guard let url = URL(string: urlString) else { return }
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let params = parameters {
//            request.httpBody = printableParams(dictionary: params).data(using: .utf8)
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            let result = self.getResponseFromData(data: data)
            DBLogger.shared.logMessage(message: "Response for URL \(urlString) is: \(result)")
            completion(data, error)
        }
        dataTask.resume()
    }
    
    
    /**
     *  Upload multiple images and videos via multipart
     *
     *  @param serviceName  name of the service
     *  @param imagesArray  array having images in NSData form
     *  @param videosArray  array having videos file path
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    
    /*
     func requestMultiPart(withServiceName serviceName: String,
     requestMethod method: HTTPMethod,
     requestImages arrImages: [Dictionary<String, Any>],
     requestVideos arrVideos: Dictionary<String, Any>,
     requestData postData: Dictionary<String, Any>,
     showIndicator show: Bool,
     completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void {
     
     if NetworkReachabilityManager()?.isReachable == true {
     
     if show {
     CommonUtils.showHudWithNoInteraction(show: true)
     }
     
     let serviceUrl = serviceName
     let params  = getPrintableParamsFromJson(postData: postData)
     let headers = getHeaderWithAPIName(serviceName: serviceName)
     
     print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
     
     Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
     
     for (key,value) in postData {
     multipartFormData.append(self.convertToData(value),withName: key)
     }
     
     let videoDic = kSharedInstance.getDictionary(arrVideos)
     let videoData = videoDic["video"] as? Data
     
     if videoData != nil {
     multipartFormData.append(videoData!,
     withName: videoDic["videoName"] as! String,
     fileName: "messagevideo.mp4",
     mimeType: "video/mp4")
     }
     
     for dictImage in arrImages {
     let validDict = kSharedInstance.getDictionary(dictImage)
     if let image = validDict["image"] as? UIImage {
     if let imageData: Data = image.jpegData(compressionQuality: 0.5) {
     multipartFormData.append(imageData, withName: String.getString(validDict["imageName"]), fileName: String.getString(NSNumber.getNSNumber(message: self.getCurrentTimeStamp()).intValue) + ".jpeg", mimeType: "image/jpeg")
     }
     }
     }
     }, to: serviceUrl, method: method, headers:headers, encodingCompletion: { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
     
     if show {
     CommonUtils.showHudWithNoInteraction(show: false)
     }
     
     switch encodingResult {
     case .success(request: let upload,
     streamingFromDisk: _,
     streamFileURL: _):
     upload.responseJSON(completionHandler: { (Response) in
     let response = self.getResponseDataDictionaryFromData(data: Response.data!)
     completionClosure(response.responseData,
     response.error,
     .requestSuccess,
     Int.getInt(Response.response?.statusCode))
     })
     case .failure(let error):
     completionClosure(nil, error, .requestFailed, 200)
     }
     })
     } else {
     completionClosure(nil, nil, .noNetwork, nil)
     }
     }
     */
    
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

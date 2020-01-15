//
//  DBNetworkManager.swift
//  DBNetworkKit
//
//  Created by Nitin A on 15/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import Foundation

let k_debug = true

public enum kHTTPMethod: String {
    case kGET = "GET"
    case kPOST = "POST"
}

public enum ErrorType: Error {
    case noNetwork, requestSuccess, requestFailed, requestCancelled
}

public class DBNetworkManager {
    
    // MARK: - Public Methods
    public static let shared: DBNetworkManager = DBNetworkManager()
    
    public func startNetworkMonitor() {
        print("Network monitoring start....")
        NetworkReachability.shared.startMonitoring()
//        NetworkReachability.shared.didStartMonitoringHandler = { [unowned self] in
//            print("Network monitoring stop....")
//           // NetworkReachability.shared.stopMonitoring()
//        }
    }
    
    public func sendRequest(urlString: String,
                            method: kHTTPMethod,
                            parameters: [String: Any]?,
                            completion: @escaping (_ result: Any?, _ error: Error?) -> ()) -> Void {
        
        if k_debug {
            print("Connecting with URL \(urlString) with parameters: \(parameters)")
        }
        
       // print("is enabled: \(NetworkReachability.shared.isConnected)")
        
        
        guard let url = URL(string: urlString) else { return }
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let params = parameters {
            request.httpBody = printableParams(dictionary: params).data(using: .utf8)
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            let result = self.getResponseFromData(data: data)
            if k_debug {
                print("Response for URL \(urlString) is: \(result)")
            }
            completion(result.responseData, nil)
//
//            DispatchQueue.main.async {
//
//            }
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
    
    private func getResponseFromData(data: Data?) -> (responseData: Any?, error: Error?) {
        guard let data = data else { return (nil, nil) }
        do {
            let responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return (responseData, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    func timeStamp()-> TimeInterval {
        return Date().timeIntervalSince1970.rounded()
    }
}

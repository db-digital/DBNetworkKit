//
//  ViewController.swift
//  DBNetworkApp
//
//  Created by Nitin A on 15/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBNetworkKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  testNetworkRequest()
    }

    
    
    private func testNetworkRequest() {
        
    
        let urlString = "https://appfeedlight.bhaskar.com/appFeedV3/NewsByProviderId/521/1914/PG1/"
        DBNetworkManager.shared.sendRequest(urlString: urlString,
                                            method: .get,
                                            parameters: nil)
        { (result, error) in
            print("error: ", error as Any)
            print("result: ", result as Any)
        }
    }
}


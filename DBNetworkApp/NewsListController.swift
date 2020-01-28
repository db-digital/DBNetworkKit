//
//  NewsListController.swift
//  DBNetworkApp
//
//  Created by Nitin A on 15/01/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit
import DBNetworkKit
import DBLoggingKit

class NewsListController: UITableViewController {

    private var pageIndex = 1
    private var kTitles: [String] = []
    private var isRequestLoading: Bool = false
    private var paginationAvailable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchNews()
       // samplePostRequest()
    }
    
    private func initialSetup() {
//        DBNetworkManager.shared.authenticateWithCompletion(completion: { (response, error) in
//            DBLogger.shared.logMessage(message: "response from server for authentication is \(response) with error \(error)")
//        })
        
        DBNetworkManager.shared.getCityListWithCompletion(completion: { (response, error) in
            DBLogger.shared.logMessage(message: "response from server for cities list is \(response) with error \(error)")
        })
        
        view.backgroundColor = .white
        title = "News"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
    }
    
    private func samplePostRequest() {
        DBNetworkManager.shared.sendRequest(urlString: "https://reqres.in/api/users",
                                            method: .post,
                                            parameters: ["name": "nitinaggarwal@gmail.com", "job": "12345678"])
        { (result, error) in
            print(result as Any)
            print(error as Any)
        }
    }
    
    private func fetchNews() {
        self.isRequestLoading = true
        let urlString = "https://appfeedlight.bhaskar.com/appFeedV3/GuruvaniTopicVideo/960/19/PG\(self.pageIndex)/"
//        DBNetworkManager.shared.sendRequest(urlString: urlString,
//                                            method: .get,
//                                            parameters: nil)
//        { (result, error) in
//            self.isRequestLoading = false
//            if let response = result as? [String: Any], let feedArray = response["feed"] as? [[String: Any]], feedArray.isEmpty == false {
//                let titles = feedArray.map { (feedDictionary) -> String in
//                    return feedDictionary["title"] as? String ?? "Empty"
//                }
//                self.kTitles.append(contentsOf: titles)
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                self.pageIndex += 1
//                self.paginationAvailable = true
//                return
//            }
//            self.paginationAvailable = false
//        }
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kTitles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = kTitles[indexPath.row]
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0, scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height - 200) {
            if paginationAvailable, !isRequestLoading {
                self.fetchNews()
            }
        }
    }
}
